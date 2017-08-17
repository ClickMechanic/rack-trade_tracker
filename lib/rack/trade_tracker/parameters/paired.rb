require_relative '../parameters'

module Rack
  class TradeTracker
    module Parameters

      class Paired
        PERMITTED_PARAMS = %w(campaignID materialID affiliateID redirectURL)

        def initialize(params)
          extract(params)
        end

        private

        def extract(params)
          PERMITTED_PARAMS.each do |param|
            class_eval do
              define_method param.underscore do
                params[param] || MISSING_PARAM_VALUE
              end
            end
          end
        end
      end

    end
  end
end
