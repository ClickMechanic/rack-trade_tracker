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

      context 'with paired parameters' do
        let(:params) { 'campaignID=ABC123&redirectURL=www.your-proper-url.com' }

        it 'redirects to the trackback URL' do
          status, headers, body = subject.call(env)
          expect(status).to eq 301
          expect(headers['Location']).to eq Rack::TradeTracker::TRACKBACK_URL
        end

        context 'with missing redirect URL' do
          let(:params) { 'campaignID=ABC123' }

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
      end

      context 'with delimited parameters' do
        let(:params) { 'tt=ABC123_123456&r=www.your-proper-url.com' }

        it 'redirects to the trackback URL' do
          status, headers, body = subject.call(env)
          expect(status).to eq 301
          expect(headers['Location']).to eq Rack::TradeTracker::TRACKBACK_URL
        end

        context 'with missing redirect URL' do
          let(:params) { 'tt=ABC123_123456' }

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
      end
    end
  end
end
