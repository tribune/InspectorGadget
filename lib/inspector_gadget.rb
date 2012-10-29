module InspectorGadget
  def self.included(base)
    base.class_eval do
      # setting up alias_method_chain
      (instance_methods - Object.methods).each do |method_name|
        method_name = method_name.to_s # convert symbol to string
        if ['?', '='].include?(method_name[-1])
          special_character = method_name[-1]
          bare_method_name = method_name[0..-2] # get rid of trailing "=" or "?"
          method_with_logging_name = bare_method_name + '_with_logging' + special_character
          method_without_logging_name = bare_method_name + '_without_logging' + special_character
        else
          method_with_logging_name = method_name + '_with_logging'
          method_without_logging_name = method_name + '_without_logging'
        end
        define_method(method_with_logging_name) do |*args|
          args_to_log = args.dup
          filter_args(method_name, args_to_log)
          Rails.logger.info "#{self.class.name} LOG: method name: #{method_name}, args: #{args_to_log.inspect}"
          result = send(method_without_logging_name, *args)
          result_to_log = result.dup rescue result
          filter_result(method_name, result_to_log)
          Rails.logger.info "#{self.class.name} LOG: method name: #{method_name}, args: #{args_to_log.inspect} returned #{result_to_log.inspect}"
          result
        end

        alias_method_chain method_name, :logging

        # override this method to hide passwords etc
        def filter_args(method_name, args)
        end

        # override this method to hide passwords etc
        def filter_result(method_name, result)
        end
      end
    end
  end
end

