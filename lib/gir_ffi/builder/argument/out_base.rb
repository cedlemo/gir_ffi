module GirFFI
  module Builder
    module Argument
      # Abstract base class implementing argument processing for arguments
      # with direction :out.
      class OutBase < Base
        def prepare
          @name = safe(@arginfo.name)
          @callarg = @function_builder.new_var
          @retname = @function_builder.new_var
        end

        def pre
          [ "#{@callarg} = GirFFI::ArgHelper.#{base_type}_outptr" ]
        end
      end
    end
  end
end

