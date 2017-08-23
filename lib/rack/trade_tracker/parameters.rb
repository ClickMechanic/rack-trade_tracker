require 'active_support/core_ext/string'

require_relative 'parameters/paired'
require_relative 'parameters/delimited'

module Rack
  class TradeTracker
    class Parameters
      CAMPAIGN_ID_PARAM = 'campaignID'.freeze
      TT_PARAM = 'tt'.freeze
      MISSING_PARAM_VALUE = ''.freeze
      PERMITTED_PARAMS = %w(campaignID materialID affiliateID reference).freeze

      MissingParametersError = Class.new(RuntimeError)


      def initialize(params)
        @params = params
        if params.include?(CAMPAIGN_ID_PARAM)
          extend Paired
        elsif params.include?(TT_PARAM)
          extend Delimited
        else
          fail MissingParametersError.new("URL must include either '#{CAMPAIGN_ID_PARAM}' or '#{TT_PARAM}' parameter")
        end
      end

      def to_hash
        PERMITTED_PARAMS.each_with_object({}) do |param, result|
          key = param.underscore.to_sym
          result[key] = send(key)
        end.merge(redirect_url: redirect_url)
      end

      private

      attr_reader :params
    end
  end
end
