module Sidekiq
  module Enqueuer
    module Model
      class Param
        class NoProvidedValueForRequiredParam < StandardError; end
        attr_accessor :name, :is_required
        def initialize name, label
          @name = name
          @is_required = (label == :req)
        end

        class << self
          def check_params request_params, params
            results = {}
            params.map do |param|
              result = request_params[param.name.to_s] || ''
              result = convert_to_appropriate_datatype(result)
              raise NoProvidedValueForRequiredParam if param.is_required && result.nil?
              results[param.name] = result
            end
          end

          private
          def convert_to_appropriate_datatype str
            return true if str == 'true'
            return false if str == 'false'
            return nil if str == 'nil'
            return nil if str.length == 0
            n = Float(str) rescue nil
            return n if n && str.include?('.')
            n = Integer(str) rescue nil
            return n unless n.nil?
            return str
          end
        end

      end
    end
  end
end
