require_relative '../parameters'

module Rack
  class TradeTracker
    module Parameters

      class Delimited
        include Parameters

        DELIMITER = '_'.freeze
        REDIRECT_PARAM = 'r'.freeze

        def initialize(params)
          extract(params)
        end

        private

        def extract(params)
          param = params[TT_PARAM]

          values = param.present? ? param.split(DELIMITER) : []

          PERMITTED_PARAMS.each_with_index do |param, index|
            class_eval do
              define_method param.underscore do
                values[index] || MISSING_PARAM_VALUE
              end
            end
          end

          class_eval do
            define_method :redirect_url do
              params[REDIRECT_PARAM] || MISSING_PARAM_VALUE
            end
          end
        end
      end

    end
  end
end
