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

        [301, {'Location' => TRACKBACK_URL}, []]
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
        [302, {'Location' => request.base_url}, []]
      end
    end

  end
end
