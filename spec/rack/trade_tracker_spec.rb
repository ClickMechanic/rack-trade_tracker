require 'spec_helper'

RSpec.describe Rack::TradeTracker do
  let(:app) { ->(env) { [200, env, 'app'] } }
  let(:domain) { 'test.com' }
  let(:path) { '/path' }

  subject { Rack::TradeTracker.new(app, domain: domain, path: path) }
  
  it 'has a version number' do
    expect(Rack::TradeTracker::VERSION).not_to be nil
  end

  it 'requires a domain' do
    expect { Rack::TradeTracker.new(app, path: path) }.to raise_error(Rack::TradeTracker::InitializationError)
  end

  it 'requires a path' do
    expect { Rack::TradeTracker.new(app, domain: domain) }.to raise_error(Rack::TradeTracker::InitializationError)
  end

  describe 'call' do
    let(:env) { env_for(url) }
    let(:url)  { 'www.example.com/path' }

    it 'delegates to the Handler' do
      handler = double(:handler)
      allow(Rack::TradeTracker::Handler).to receive(:new).with(domain, path, app).and_return(handler)
      expect(handler).to receive(:call).with(env)
      subject.call(env)
    end
  end
end
