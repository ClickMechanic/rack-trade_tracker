require_relative '../parameters'

module Rack
  class TradeTracker
    module Parameters

      class Paired
        include Parameters

        REDIRECT_PARAM = 'redirectURL'.freeze

        def initialize(params)
          extract(params)
        end

        private

        def extract(params)
          (PERMITTED_PARAMS.dup << REDIRECT_PARAM).each do |param|
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
