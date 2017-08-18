require_relative "trade_tracker/version"
require_relative "trade_tracker/parameters"

module Rack

  class TradeTracker
    
    InitializationError = Class.new(RuntimeError)
    
    def initialize(app, options = {})
      @app = app
      raise InitializationError.new('options must include :domain_name') unless (@domain = options[:domain])
      raise InitializationError.new('options must include :domain_name') unless (@path = options[:path])
    end

    def call(env)
      @app.call(env)
    end
    
    private
    
    attr_reader :domain, :path
  end

end
