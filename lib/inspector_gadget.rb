module InspectorGadget

  def self.included(base)
    # log all instance methods
    Brain.log_all_instance_method_calls(base)

    # log all class methods
    singleton_class = class << base; self; end
    Brain.log_all_instance_method_calls(singleton_class)
  end

  module Brain
    # obj either a class (instance methods) or a class singleton (class methods)
    def self.log_all_instance_method_calls(obj)
      # setting up alias_method_chain
      obj.class_eval do
        (instance_methods - Object.methods).each do |method_name|
          method_name = method_name.to_s # convert symbol to string
          aliased_target, punctuation = method_name.to_s.sub(/([?!=])$/, ''), $1
          method_with_logging_name, method_without_logging_name = "#{aliased_target}_with_logging#{punctuation}", "#{aliased_target}_without_logging#{punctuation}"

          define_method(method_with_logging_name) do |*args, &block|
            args_to_log = args.dup
            filter_args_in_log(method_name, args_to_log)
            if self.is_a?(Class)
              method_type = 'class'
              class_name = self.name
            else
              method_type = 'instance'
              class_name = self.class.name
            end
            Rails.logger.info("#{class_name} LOG: #{method_type} method name: #{method_name}, args: #{args_to_log.inspect}")
            result = send(method_without_logging_name, *args, &block)
            result_to_log = result.dup rescue result
            filter_result_in_log(method_name, result_to_log)
            Rails.logger.info("#{class_name} LOG: #{method_type} method name: #{method_name}, args: #{args_to_log.inspect} returned #{result_to_log.inspect}")
            result
          end

          alias_method_chain method_name, :logging

          # override this method to hide passwords etc
          def filter_args_in_log(method_name, args)
          end

          # override this method to hide passwords etc
          def filter_result_in_log(method_name, result)
          end
        end
      end
    end
  end
end

