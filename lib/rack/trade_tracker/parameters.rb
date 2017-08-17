require 'active_support/core_ext/string'

require_relative 'parameters/paired'
require_relative 'parameters/delimited'

module Rack
  class TradeTracker
    module Parameters
      CAMPAIGN_ID_PARAM = 'campaignID'
      TT_PARAM = 'tt'
      MISSING_PARAM_VALUE = ''

      class << self
        def build(params)
          extract(params)
        end

        private

        def extract(params)
          params.include?(CAMPAIGN_ID_PARAM) ? Paired.new(params) : Delimited.new(params)
        end
      end

    end
  end
end
