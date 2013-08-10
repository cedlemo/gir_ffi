require 'gir_ffi/builder_helper'

module GirFFI
  module InfoExt
    # Extensions for GObjectIntrospection::IArgInfo needed by GirFFI
    module ITypeInfo
      include BuilderHelper

      def g_type
        tag = self.tag
        case tag
        when :interface
          interface.g_type
        else
          GObject::TYPE_TAG_TO_GTYPE[tag]
        end
      end

      def make_g_value
        GObject::Value.for_g_type g_type
      end

      def element_type
        case tag
        when :glist, :gslist, :array
          subtype_tag_or_class 0
        when :ghash
          [subtype_tag_or_class(0), subtype_tag_or_class(1)]
        else
          nil
        end
      end

      def interface_type_name
        interface.full_type_name
      end

      def flattened_tag
        type_tag = self.tag
        case type_tag
        when :interface
          interface_type
        when :array
          flattened_array_type
        else
          type_tag
        end
      end

      def interface_type
        tag == :interface && interface.info_type
      end

      def subtype_tag_or_class_name index = 0
        param_type(index).tag_or_class_name
      end

      def subtype_tag_or_class index = 0
        param_type(index).tag_or_class
      end

      def tag_or_class_name
        tag_or_class.inspect
      end

      def tag_or_class
        type_tag = self.tag
        base = if type_tag == :interface
                 Builder.build_class interface
               else
                 type_tag
               end
        if pointer? && type_tag != :utf8 && type_tag != :filename || interface_type == :object
          [:pointer, base]
        else
          base
        end
      end

      def to_ffitype
        return :pointer if pointer?

        type_tag = tag
        case type_tag
        when :interface
          interface.to_ffitype
        when :array
          subtype = param_type(0).to_ffitype
          # NOTE: Don't use pointer directly to appease JRuby.
          if subtype == :pointer
            subtype = :"uint#{FFI.type_size(:pointer)*8}"
          end
          [subtype, array_fixed_size]
        else
          TypeMap.map_basic_type type_tag
        end
      end

      def to_callback_ffitype
        type_tag = tag

        return :string if type_tag == :utf8
        return :pointer if pointer?

        if type_tag == :interface
          case interface.info_type
          when :enum, :flags
            :int32
          else
            :pointer
          end
        else
          return TypeMap.map_basic_type type_tag
        end
      end

      private

      def flattened_array_type
        if zero_terminated?
          zero_terminated_array_type
        else
          array_type
        end
      end

      def zero_terminated_array_type
        case element_type
        when :utf8, :filename
          :strv
        else
          :zero_terminated
        end
      end
    end
  end
end

GObjectIntrospection::ITypeInfo.send :include, GirFFI::InfoExt::ITypeInfo
