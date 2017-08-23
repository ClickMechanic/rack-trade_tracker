require_relative '../parameters'

module Rack
  class TradeTracker
    class Parameters

      module Delimited
        DELIMITER = '_'.freeze
        REDIRECT_PARAM = 'r'.freeze

        def self.extended(base)
          values = base.instance_eval do
            param = params[TT_PARAM]
            param.present? ? param.split(DELIMITER) : []
          end

          PERMITTED_PARAMS.each_with_index do |param, index|
            define_method param.underscore do
              values[index] || MISSING_PARAM_VALUE
            end
          end
        end


        def redirect_url
          params[REDIRECT_PARAM] || MISSING_PARAM_VALUE
        end
      end

    end
  end
end
