module Rack
  class TradeTracker

    class Cookie
      NAME = 'TT2_%{campaign_id}'.freeze
      DIGEST_PARAMS = [:campaign_id, :material_id, :affiliate_id, :reference].freeze
      VALUE_PARAMS = [:material_id, :affiliate_id, :reference].freeze
      PATH = '/'.freeze

      def initialize(domain, parameters)
        @domain, @parameters = domain, parameters
      end

      def name
        NAME % params_hash
      end

      def checksum
        source = "CHK_#{DIGEST_PARAMS.map { |param| params_hash[param]  }.join('::')}"
        Digest::MD5.hexdigest(source)
      end

      def timestamp
        Time.now.to_i
      end

      def value
        VALUE_PARAMS.map { |param| params_hash[param] }.tap do |attributes|
          attributes << checksum << timestamp
        end.join('::')
      end

      def as_hash
        {
            value: value,
            domain: ".#{domain}",
            path: PATH,
            expires: 1.year.from_now
        }
      end

      private

      attr_reader :domain, :parameters

      def params_hash
        @_params_hash ||= parameters.to_hash
      end
    end

  end
end
