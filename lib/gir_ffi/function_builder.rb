require 'gir_ffi/argument_builder'
require 'gir_ffi/return_value_builder'
require 'gir_ffi/error_argument_builder'
require 'gir_ffi/null_argument_builder'
require 'gir_ffi/variable_name_generator'

module GirFFI
  # Implements the creation of a Ruby function definition out of a GIR
  # IFunctionInfo.
  class FunctionBuilder
    def initialize info, libmodule
      @info = info
      @libmodule = libmodule
    end

    def generate
      vargen = GirFFI::VariableNameGenerator.new
      @argument_builders = @info.args.map {|arg| ArgumentBuilder.new vargen, arg }
      @return_value_builder = ReturnValueBuilder.new(vargen, @info.return_type,
                                                     @info.constructor?)

      link_array_length_arguments
      setup_error_argument vargen
      return filled_out_template
    end

    private

    def link_array_length_arguments
      alldata = @argument_builders.dup << @return_value_builder

      alldata.each {|data|
        idx = data.type_info.array_length
        if idx > -1
          other_data = @argument_builders[idx]
          data.length_arg = other_data
          other_data.array_arg = data
        end
      }
    end

    def setup_error_argument vargen
      klass = @info.throws? ? ErrorArgumentBuilder : NullArgumentBuilder
      @errarg = klass.new vargen, nil, nil, :error
    end

    def filled_out_template
      meta = @info.method? ? '' : "self."

      code = "def #{meta}#{@info.safe_name} #{method_arguments.join(', ')}\n"
      code << method_body
      code << "\nend\n"
    end

    def method_body
      lines = preparation << function_call << post_processing << cleanup
      lines << "return #{return_values.join(', ')}" if has_return_values?
      lines.flatten.join("\n").indent
    end

    def function_call
      "#{capture}#{@libmodule}.#{@info.symbol} #{function_call_arguments.join(', ')}"
    end

    def method_arguments
      @argument_builders.map(&:inarg).compact
    end

    def function_call_arguments
      ca = @argument_builders.map(&:callarg)
      ca << @errarg.callarg
      ca.unshift "self" if @info.method?
      ca.compact
    end

    def preparation
      pr = @argument_builders.map(&:pre)
      pr << @errarg.pre
      pr.flatten
    end

    def capture
      if has_capture?
        "#{@return_value_builder.callarg} = "
      else
        ""
      end
    end

    def post_processing
      # FIXME: Sorting knows too much about internals of ArgumentBuilder.
      args = @argument_builders.sort_by {|arg| arg.type_info.array_length}
      args << @return_value_builder
      args.unshift @errarg

      args.map {|arg| arg.post}
    end

    def cleanup
      @argument_builders.map {|item| item.cleanup}
    end

    def return_values
      @return_values ||= ([@return_value_builder.retval] +
                          @argument_builders.map(&:retval)).compact
    end

    def has_return_values?
      !return_values.empty?
    end

    def has_capture?
      @return_value_builder.is_relevant?
    end
  end
end
