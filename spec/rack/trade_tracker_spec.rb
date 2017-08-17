require 'spec_helper'

RSpec.describe Rack::TradeTracker do
  let(:app) { ->(env) { [200, env, 'app'] } }
  
  subject { Rack::TradeTracker.new(app, domain_name: 'test.com') }
  
  it 'has a version number' do
    expect(Rack::TradeTracker::VERSION).not_to be nil
  end

  it 'requires a domain name' do
    expect { Rack::TradeTracker.new(app) }.to raise_error(Rack::TradeTracker::InitializationError)
  end
end
