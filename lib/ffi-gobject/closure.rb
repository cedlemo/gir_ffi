# frozen_string_literal: true
GObject.load_class :Closure

module GObject
  # Overrides for GClosure, GObject's base class for closure objects.
  #
  # To create Closure objects wrapping Ruby code, use {RubyClosure}.
  class Closure
    setup_method :new_simple

    # @override
    #
    # @param [Proc] marshal The marshaller to use for this closure object
    def set_marshal(marshal)
      callback = GObject::ClosureMarshal.from marshal
      Lib.g_closure_set_marshal self, callback
    end
  end
end
