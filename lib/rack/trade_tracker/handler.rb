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

      LOGGER_REGEX = /logger/i

      def initialize(domain, path, app)
        @domain = domain
        @path = path
        @app = app
      end

      def call(env)
        @env = env
        @request = Rack::Request.new(env)

        return @app.call(env) unless matches_path?

        begin
          redirect
        rescue Parameters::MissingParametersError
          redirect_to_root
        end
      end

      private

      attr_reader :domain, :path, :app, :env, :request, :cookie

      def matches_path?
        request.path == path
      end

      def parameters
        @_parameters ||= Parameters.build(request.params)
      end

      def params_hash
        @_params_hash ||= parameters.to_hash
      end

      def redirect_to_root
        response(302, {'Location' => request.base_url} ) do
          log("Redirecting to root as Trade Tracker parameters missing", :error)
        end
      end

      def redirect
        response(301, {'Location' => redirect_url} ) do |response|
          set_cookie(response)
          set_p3p_header(response)
          log("Redirecting to Trade Tracker with cookie: #{URI.encode(cookie.value)}")
        end
      end

      def redirect_url
        url = URI(TRACKBACK_URL)
        params = PARAMS_MAP.keys.each_with_object({}) { |param, result| result[PARAMS_MAP[param]] = params_hash[param] }
        url.query = params.map { |k,v| "#{k}=#{URI.encode(v)}" }.join('&')
        url.to_s
      end

      def response(status, header)
        Rack::Response.new([], status, header).tap do |response|
          yield response if block_given?
        end.finish
      end

      def set_cookie(response)
        @cookie ||= Cookie.new(domain, parameters)
        response.set_cookie(cookie.name, cookie.as_hash)
      end

      def set_p3p_header(response)
        response.headers['P3P'] = 'CP="ALL PUR DSP CUR ADMi DEVi CONi OUR COR IND"'
      end

      def log(message, level = :info)
        return unless logger

        logger.send(level, message) if logger.respond_to?(level)
      end

      def logger
        @logger ||= env.find { |key, _| LOGGER_REGEX.match(key) }&.[] 1
      end
    end

  end
end
