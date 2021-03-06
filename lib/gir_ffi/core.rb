# frozen_string_literal: true
require 'ffi'
require 'ffi/bit_masks'

require 'gir_ffi-base'

require 'ffi-gobject_introspection'

require 'gir_ffi/ffi_ext'
require 'gir_ffi/class_base'
require 'gir_ffi/type_map'
require 'gir_ffi/info_ext'
require 'gir_ffi/in_pointer'
require 'gir_ffi/in_out_pointer'
require 'gir_ffi/sized_array'
require 'gir_ffi/zero_terminated'
require 'gir_ffi/arg_helper'
require 'gir_ffi/builder'
require 'gir_ffi/user_defined_type_info'
require 'gir_ffi/builders/user_defined_builder'
require 'gir_ffi/version'

# Main module containing classes and modules needed for generating GLib and
# GObject bindings.
module GirFFI
  def self.setup(namespace, version = nil)
    namespace = namespace.to_s
    GirFFI::Builder.build_module namespace, version
  end

  def self.define_type(klass, &block)
    info = UserDefinedTypeInfo.new(klass, &block)
    Builders::UserDefinedBuilder.new(info).build_class

    klass.gtype
  end
end
