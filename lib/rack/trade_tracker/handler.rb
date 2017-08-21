require 'active_support/core_ext/integer/time'
require_relative 'cookie'

module Rack
  class TradeTracker

    class Handler
      PARAMS_MAP = {campaign_id: :c,
                    material_id: :m,
                    affiliate_id: :a,
                    reference: :r,
                    redirect_url: :u}

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

      def params_hash
        @_params_hash ||= parameters.to_hash
      end

      def redirect_to_root
        Rack::Response.new([], 302, {'Location' => request.base_url} ).finish
      end

      def redirect
        response = Rack::Response.new([], 301, {'Location' => redirect_url} )
        set_cookie(response)
        set_p3p_header(response)
        response.finish
      end

      def redirect_url
        url = URI(TRACKBACK_URL)
        params = PARAMS_MAP.keys.each_with_object({}) { |param, result| result[PARAMS_MAP[param]] = params_hash[param] }
        url.query = params.map { |k,v| "#{k}=#{URI.encode(v)}" }.join('&')
        url.to_s
      end

      def set_cookie(response)
        cookie = Cookie.new(domain, parameters)
        response.set_cookie(cookie.name, cookie.as_hash)
      end

      def set_p3p_header(response)
        response.headers['P3P'] = 'CP="ALL PUR DSP CUR ADMi DEVi CONi OUR COR IND"'
      end
    end

  end
end
