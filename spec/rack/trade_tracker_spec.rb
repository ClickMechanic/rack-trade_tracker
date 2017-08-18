require 'spec_helper'

RSpec.describe Rack::TradeTracker do
  let(:app) { ->(env) { [200, env, 'app'] } }
  
  subject { Rack::TradeTracker.new(app, domain: 'test.com', path: '/path') }
  
  it 'has a version number' do
    expect(Rack::TradeTracker::VERSION).not_to be nil
  end

  it 'requires a domain' do
    expect { Rack::TradeTracker.new(app, path: '/path') }.to raise_error(Rack::TradeTracker::InitializationError)
  end

  it 'requires a path' do
    expect { Rack::TradeTracker.new(app, domain: 'test.com') }.to raise_error(Rack::TradeTracker::InitializationError)
  end

  describe 'call' do
    context 'with an alternate path' do
      let(:url)  { 'www.example.com/some-other-path' }
      let(:env) { env_for(url) }

      it 'passes the call along' do
        expect(app).to receive(:call).with(env)
        subject.call(env)
      end
    end
  end

  def env_for(url)
    Rack::MockRequest.env_for(url)
  end
end
