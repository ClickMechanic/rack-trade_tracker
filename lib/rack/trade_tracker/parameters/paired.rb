require_relative '../parameters'

module Rack
  class TradeTracker
    class Parameters

      module Paired
        REDIRECT_PARAM = 'redirectURL'.freeze

        def self.extended(base)
          params = base.send(:params)

          (PERMITTED_PARAMS.dup << REDIRECT_PARAM).each do |param|
            define_method param.underscore do
              params[param] || MISSING_PARAM_VALUE
            end
          end
        end
      end

    end
  end
end
