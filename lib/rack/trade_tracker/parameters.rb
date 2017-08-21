require 'active_support/core_ext/string'

require_relative 'parameters/paired'
require_relative 'parameters/delimited'

module Rack
  class TradeTracker
    module Parameters
      CAMPAIGN_ID_PARAM = 'campaignID'
      TT_PARAM = 'tt'
      MISSING_PARAM_VALUE = ''
      PERMITTED_PARAMS = %w(campaignID materialID affiliateID reference)

      MissingParametersError = Class.new(RuntimeError)

      class << self
        def build(params)
          extract(params)
        end

        private

        def extract(params)
          if params.include?(CAMPAIGN_ID_PARAM)
            Paired.new(params)
          elsif params.include?(TT_PARAM)
            Delimited.new(params)
          else
            fail MissingParametersError.new("URL must include either 'CampaignID' or 'tt' parameter")
          end
        end
      end

      def to_hash
        PERMITTED_PARAMS.each_with_object({}) do |param, result|
          key = param.underscore.to_sym
          result[key] = send(key)
        end.merge(redirect_url: redirect_url)
      end

    end
  end
end
