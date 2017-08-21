require 'spec_helper'

RSpec.describe Rack::TradeTracker::Handler do
  let(:app) { ->(env) { [200, env, 'app'] } }
  let(:domain) { 'test.com' }
  let(:path) { '/path' }

  subject { Rack::TradeTracker::Handler.new(domain, path, app) }

  describe 'call' do
    let(:env) { env_for(url) }

    context 'with an alternate path' do
      let(:url)  { 'http://www.example.com/some-other-path' }

      it 'passes the call along' do
        expect(app).to receive(:call).with(env)
        subject.call(env)
      end
    end

    context 'with a matching path' do
      let(:url)  { URI.escape("http://www.example.com/path?#{params}") }
      let(:cookie) { double :cookie, name: 'TT2_ABCDEF', value: '123456::ABC123::ref', as_hash: {value: '123456::ABC123::ref',
                                                                   expires: 1.year.from_now,
                                                                   path: '/',
                                                                   domain: domain} }

      shared_examples 'redirects with cookie' do |redirect_url|
        attr_reader :status, :headers, :body, :trackback_url, :query

        before do
          allow(Rack::TradeTracker::Cookie).to receive(:new).and_return(cookie)
          @status, @headers, @body = subject.call(env)
          url = URI(headers['Location'])
          @trackback_url = URI::HTTP.build(host: url.host).to_s
          @query = url.query.split('&').map { |attr| attr.split('=', -1) }.to_h if url.query
        end

        it 'redirects to the trackback URL' do
          expect(status).to eq 301
          expect(trackback_url).to eq Rack::TradeTracker::TRACKBACK_URL
        end

        it 'includes the campaign_id parameter' do
          expect(query['c']).to eq 'ABCDEF'
        end

        it 'includes the material_id parameter' do
          expect(query['m']).to eq '123456'
        end

        it 'includes the affiliate_id parameter' do
          expect(status).to eq 301
          expect(query['a']).to eq 'ABC123'
        end

        it 'includes the redirect_url parameter' do
          expect(status).to eq 301
          expect(query['u']).to eq redirect_url
        end

        it 'creates the Trade Tracker cookie' do
          cookie_value = "123456%3A%3AABC123%3A%3Aref; domain=test.com; path=/; expires=#{Rack::Utils.rfc2822(cookie.as_hash[:expires].utc)}"
          expect(headers['set-cookie']).to eq "#{cookie.name}=#{cookie_value}"
        end

        it 'adds the P3P header' do
          expect(headers['P3P']).to eq 'CP="ALL PUR DSP CUR ADMi DEVi CONi OUR COR IND"'
        end

        context 'with a logger defined in the rack env' do
          let(:logger) { double :logger, info: nil }

          before { env['rack.logger'] = logger }

          it 'logs the redirect' do
            subject.call(env)
            expect(logger).to have_received(:info).with("Redirecting to Trade Tracker with cookie: #{URI.encode('123456::ABC123::ref')}")
          end
        end
      end

      context 'with paired parameters' do
        include_examples 'redirects with cookie', 'www.your-proper-url.com' do
          let(:params) { 'campaignID=ABCDEF&materialID=123456&affiliateID=ABC123&redirectURL=www.your-proper-url.com' }
        end

        context 'with missing redirect URL' do
          include_examples 'redirects with cookie', '' do
            let(:params) { 'campaignID=ABCDEF&materialID=123456&affiliateID=ABC123' }
          end
        end
      end

      context 'with delimited parameters' do
        include_examples 'redirects with cookie', 'www.your-proper-url.com' do
          let(:params) { 'tt=ABCDEF_123456_ABC123_ref&r=www.your-proper-url.com' }
        end

        context 'with missing redirect URL' do
          include_examples 'redirects with cookie', '' do
            let(:params) { 'tt=ABCDEF_123456_ABC123_ref' }
          end
        end
      end

      context 'with missing campaignID and tt parameters' do
        let(:params) { '' }

        it 'redirects to root with 302' do
          status, headers, body = subject.call(env)
          expect(status).to eq 302
          expect(headers['Location']).to eq 'http://www.example.com'
        end

        it 'does not forward the request' do
          expect(app).not_to receive(:call)
          subject.call(env)
        end

        context 'with a logger defined in the rack env' do
          let(:logger) { double :logger, error: nil }

          before { env['rack.logger'] = logger }

          it 'logs the redirect' do
            subject.call(env)
            expect(logger).to have_received(:error).with('Redirecting to root as Trade Tracker parameters missing')
          end
        end
      end
    end
  end
end
