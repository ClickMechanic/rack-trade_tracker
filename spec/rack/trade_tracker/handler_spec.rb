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
      let(:cookie) { double :cookie, name: 'TT2_ABCDEF', as_hash: {value: '123456::ABC123::ref',
                                                                   expires: 1.year.from_now,
                                                                   path: '/',
                                                                   domain: domain} }

      shared_examples 'redirects with cookie' do
        attr_reader :status, :headers, :body, :redirect_url, :query

        before do
          allow(Rack::TradeTracker::Cookie).to receive(:new).and_return(cookie)
          @status, @headers, @body = subject.call(env)
          url = URI(headers['Location'])
          @redirect_url = URI::HTTP.build(host: url.host).to_s
          @query = url.query.split('&').map { |attr| attr.split('=', -1) }.to_h if url.query
        end

        it 'redirects to the trackback URL' do
          expect(status).to eq 301
          expect(redirect_url).to eq Rack::TradeTracker::TRACKBACK_URL
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
          expect(query['u']).to eq 'www.your-proper-url.com'
        end

        it 'creates the Trade Tracker cookie' do
          cookie_value = "123456%3A%3AABC123%3A%3Aref; domain=test.com; path=/; expires=#{Rack::Utils.rfc2822(cookie.as_hash[:expires].utc)}"
          expect(headers['set-cookie']).to eq "#{cookie.name}=#{cookie_value}"
        end
      end

      shared_examples 'missing redirect URL' do
        it 'redirects to root with 302' do
          status, headers, body = subject.call(env)
          expect(status).to eq 302
          expect(headers['Location']).to eq 'http://www.example.com'
        end

        it 'does not forward the request' do
          expect(app).not_to receive(:call)
          subject.call(env)
        end
      end

      context 'with paired parameters' do
        include_examples 'redirects with cookie' do
          let(:params) { 'campaignID=ABCDEF&materialID=123456&affiliateID=ABC123&redirectURL=www.your-proper-url.com' }
        end

        context 'with missing redirect URL' do
          include_examples 'missing redirect URL' do
            let(:params) { 'campaignID=ABCDEF' }
          end
        end
      end

      context 'with delimited parameters' do
        include_examples 'redirects with cookie' do
          let(:params) { 'tt=ABCDEF_123456_ABC123_ref&r=www.your-proper-url.com' }
        end

        context 'with missing redirect URL' do
          include_examples 'missing redirect URL' do
            let(:params) { 'tt=ABCDEF_123456' }
          end
        end
      end
    end
  end
end
