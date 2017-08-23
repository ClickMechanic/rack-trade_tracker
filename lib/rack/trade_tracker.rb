require_relative "trade_tracker/version"
require_relative "trade_tracker/parameters"
require_relative "trade_tracker/handler"

module Rack

  class TradeTracker
    TRACKBACK_URL = 'http://tc.tradetracker.net'.freeze
    
    InitializationError = Class.new(RuntimeError)
    
    def initialize(app, options = {})
      @app = app
      raise InitializationError.new('options must include :domain') unless (@domain = options[:domain])
      raise InitializationError.new('options must include :path') unless (@path = options[:path])
    end

    def call(env)
      Handler.new(domain, path, app).call(env)
    end

    private

    attr_reader :app, :domain, :path
  end

end
