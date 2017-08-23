require_relative '../parameters'

module Rack
  class TradeTracker
    class Parameters

      module Delimited
        DELIMITER = '_'.freeze
        REDIRECT_PARAM = 'r'.freeze

        def self.extended(parameters)
          parameters.send(:extract)
        end

        def redirect_url
          params[REDIRECT_PARAM] || MISSING_PARAM_VALUE
        end

        private

        def extract
          param = params[TT_PARAM]

          values = param.present? ? param.split(DELIMITER) : []

          PERMITTED_PARAMS.each_with_index do |param, index|
            class_eval do
              define_method param.underscore do
                values[index] || MISSING_PARAM_VALUE
              end
            end
          end
        end
      end

    end
  end
end
