require 'spec_helper'

RSpec.describe Rack::TradeTracker do
  let(:app) { ->(env) { [200, env, 'app'] } }
  
  subject { Rack::TradeTracker.new(app, domain: 'test.com') }
  
  it 'has a version number' do
    expect(Rack::TradeTracker::VERSION).not_to be nil
  end

  it 'requires a domain' do
    expect { Rack::TradeTracker.new(app, path: '/path') }.to raise_error(Rack::TradeTracker::InitializationError)
  end

  it 'requires a path' do
    expect { Rack::TradeTracker.new(app, domain: 'test.com') }.to raise_error(Rack::TradeTracker::InitializationError)
  end

end
