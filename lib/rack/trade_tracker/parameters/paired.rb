require_relative '../parameters'

module Rack
  class TradeTracker
    class Parameters

      module Paired
        REDIRECT_PARAM = 'redirectURL'.freeze

        def self.extended(parameters)
          parameters.send(:extract)
        end

        private

        def extract
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
