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

        return @app.call(env) unless matches_path?

        return redirect_to_root unless valid_params?

        redirect
      end

      private

      attr_reader :domain, :path, :app, :env, :request

      def matches_path?
        request.path == path
      end

      def valid_params?
        !parameters.redirect_url.empty?
      end

      def parameters
        @_parameters ||= Parameters.build(request.params)
      end

      def redirect_to_root
        Rack::Response.new([], 302, {'Location' => request.base_url} ).finish
      end

      def redirect
        response = Rack::Response.new([], 301, {'Location' => TRACKBACK_URL} )
        response.finish
      end
    end

  end
end
