# frozen_string_literal: true
require 'gir_ffi/error_type_info'

module GirFFI
  # Represents an error argument with the same interface as IArgumentInfo
  class ErrorArgumentInfo
    def skip?
      false
    end

    def direction
      :error
    end

    def argument_type
      @argument_type ||= ErrorTypeInfo.new
    end

    def name
      '_error'
    end

    def closure
      -1
    end

    def destroy
      -1
    end

    def caller_allocates?
      true
    end
  end
end
