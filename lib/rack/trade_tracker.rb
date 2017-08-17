require "rack/trade_tracker/version"
require "rack/trade_tracker/parameters"

module Rack
  class TradeTracker
    
    InitializationError = Class.new(RuntimeError)
    
    def initialize(app, options = {})
      @app = app
      @domain_name = options[:domain_name]
      raise InitializationError.new('options must include :domain_name') unless @domain_name
    end
    
    private
    
    attr_reader :domain_name
  end
end
