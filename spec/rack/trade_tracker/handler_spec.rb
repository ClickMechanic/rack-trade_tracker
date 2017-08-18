require 'spec_helper'

RSpec.describe Rack::TradeTracker::Handler do
  let(:app) { ->(env) { [200, env, 'app'] } }
  let(:domain) { 'test.com' }
  let(:path) { '/path' }

  subject { Rack::TradeTracker::Handler.new(domain, path, app) }

  describe 'call' do
    let(:env) { env_for(url) }

    context 'with an alternate path' do
      let(:url)  { 'www.example.com/some-other-path' }

      it 'passes the call along' do
        expect(app).to receive(:call).with(env)
        subject.call(env)
      end
    end
  end
end
