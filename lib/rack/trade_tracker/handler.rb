module Rack
  class TradeTracker

    class Handler
      def initialize(domain, path, app)
        @domain = domain
        @path = path
        @app = app
      end

      def call(env)
        @env = env
        @request = Rack::Request.new(env)

        @app.call(env) and return unless matches_path?
      end

      private

      attr_reader :domain, :path, :app, :env, :request

      def matches_path?

      end
    end

  end
end
