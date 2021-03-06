# frozen_string_literal: true
require 'gir_ffi_test_helper'

describe GirFFI::Builders::VFuncBuilder do
  let(:builder) { GirFFI::Builders::VFuncBuilder.new vfunc_info }

  describe '#mapping_method_definition' do
    let(:result) { builder.mapping_method_definition }

    before do
      skip unless vfunc_info
    end

    describe 'for a vfunc with only one argument' do
      let(:vfunc_info) do
        get_vfunc_introspection_data 'GIMarshallingTests', 'Object', 'method_int8_in'
      end

      it 'returns a valid mapping method including receiver' do
        expected = <<-CODE.reset_indentation
        def self.call_with_argument_mapping(_proc, _instance, in_)
          _v1 = GIMarshallingTests::Object.wrap(_instance)
          _v2 = in_
          _proc.call(_v1, _v2)
        end
        CODE

        result.must_equal expected
      end
    end

    describe 'for a vfunc returning an enum' do
      let(:vfunc_info) do
        get_vfunc_introspection_data 'GIMarshallingTests', 'Object', 'vfunc_return_enum'
      end

      it 'returns a valid mapping method including receiver' do
        expected = <<-CODE.reset_indentation
        def self.call_with_argument_mapping(_proc, _instance)
          _v1 = GIMarshallingTests::Object.wrap(_instance)
          _v2 = _proc.call(_v1)
          _v3 = GIMarshallingTests::Enum.from(_v2)
          return _v3
        end
        CODE

        result.must_equal expected
      end
    end

    describe 'for a vfunc with a callback argument' do
      let(:vfunc_info) do
        get_vfunc_introspection_data 'GIMarshallingTests', 'Object', 'vfunc_with_callback'
      end

      it 'returns a valid mapping method including receiver' do
        expected = <<-CODE.reset_indentation
        def self.call_with_argument_mapping(_proc, _instance, callback, callback_data)
          _v1 = GIMarshallingTests::Object.wrap(_instance)
          _v2 = GIMarshallingTests::CallbackIntInt.wrap(callback)
          _v3 = GirFFI::ArgHelper::OBJECT_STORE.fetch(callback_data)
          _proc.call(_v1, _v2, _v3)
        end
        CODE

        result.must_equal expected
      end
    end

    describe 'for a vfunc with an out argument allocated by them, the caller' do
      let(:vfunc_info) do
        get_vfunc_introspection_data('GIMarshallingTests', 'Object',
                                     'method_int8_arg_and_out_caller')
      end

      it 'returns a valid mapping method including receiver' do
        expected = <<-CODE.reset_indentation
        def self.call_with_argument_mapping(_proc, _instance, arg, out)
          _v1 = GIMarshallingTests::Object.wrap(_instance)
          _v2 = arg
          _v3 = GirFFI::InOutPointer.new(:gint8, out)
          _v4 = _proc.call(_v1, _v2)
          _v3.set_value _v4
        end
        CODE

        result.must_equal expected
      end
    end

    describe 'for a vfunc with an out argument allocated by us, the callee' do
      let(:vfunc_info) do
        get_vfunc_introspection_data('GIMarshallingTests', 'Object',
                                     'method_int8_arg_and_out_callee')
      end

      it 'returns a valid mapping method including receiver' do
        expected = <<-CODE.reset_indentation
        def self.call_with_argument_mapping(_proc, _instance, arg, out)
          _v1 = GIMarshallingTests::Object.wrap(_instance)
          _v2 = arg
          _v3 = GirFFI::InOutPointer.new(:gint8).tap { |ptr| out.put_pointer 0, ptr }
          _v4 = _proc.call(_v1, _v2)
          _v3.set_value _v4
        end
        CODE

        result.must_equal expected
      end
    end

    describe 'for a vfunc with an error argument' do
      let(:vfunc_info) do
        get_vfunc_introspection_data('GIMarshallingTests', 'Object',
                                     'vfunc_meth_with_err')
      end

      it 'returns a valid mapping method including receiver' do
        expected = <<-CODE.reset_indentation
        def self.call_with_argument_mapping(_proc, _instance, x, _error)
          _v1 = GIMarshallingTests::Object.wrap(_instance)
          _v2 = x
          _v3 = GirFFI::InOutPointer.new([:pointer, :error], _error)
          begin
          _v4 = _proc.call(_v1, _v2)
          rescue => _v5
          _v3.set_value GLib::Error.from(_v5)
          end
          return _v4
        end
        CODE

        result.must_equal expected
      end
    end

    describe 'for a vfunc with a full-transfer return value' do
      let(:vfunc_info) do
        get_vfunc_introspection_data 'GIMarshallingTests', 'Object', 'vfunc_return_object_transfer_full'
      end

      it 'returns a valid mapping method' do
        expected = <<-CODE.reset_indentation
        def self.call_with_argument_mapping(_proc, _instance)
          _v1 = GIMarshallingTests::Object.wrap(_instance)
          _v2 = _proc.call(_v1)
          _v3 = GObject::Object.from(_v2.ref).to_ptr
          return _v3
        end
        CODE

        result.must_equal expected
      end
    end

    describe 'for a vfunc with a transfer-none in argument' do
      let(:vfunc_info) do
        get_vfunc_introspection_data 'GIMarshallingTests', 'Object', 'vfunc_in_object_transfer_none'
      end

      it 'returns a valid mapping method' do
        expected = <<-CODE.reset_indentation
        def self.call_with_argument_mapping(_proc, _instance, object)
          _v1 = GIMarshallingTests::Object.wrap(_instance)
          _v2 = GObject::Object.wrap(object)
          _v2.ref
          _proc.call(_v1, _v2)
        end
        CODE

        result.must_equal expected
      end
    end

    describe 'for a vfunc with a full-transfer outgoing argument' do
      let(:vfunc_info) do
        get_vfunc_introspection_data 'GIMarshallingTests', 'Object', 'vfunc_out_object_transfer_full'
      end

      it 'returns a valid mapping method' do
        expected = <<-CODE.reset_indentation
        def self.call_with_argument_mapping(_proc, _instance, object)
          _v1 = GIMarshallingTests::Object.wrap(_instance)
          _v2 = GirFFI::InOutPointer.new([:pointer, GObject::Object], object)
          _v3 = _proc.call(_v1)
          _v2.set_value GObject::Object.from(_v3.ref)
        end
        CODE

        result.must_equal expected
      end
    end
  end

  describe '#argument_ffi_types' do
    let(:result) { builder.argument_ffi_types }

    before do
      skip unless vfunc_info
    end

    describe 'for a vfunc with only one argument' do
      let(:vfunc_info) do
        get_vfunc_introspection_data 'GIMarshallingTests', 'Object', 'method_int8_in'
      end

      it 'returns the correct FFI types including :pointer for the receiver' do
        result.must_equal [:pointer, :int8]
      end
    end
  end

  describe '#return_ffi_type' do
    let(:result) { builder.return_ffi_type }

    before do
      skip unless vfunc_info
    end

    describe 'for a vfunc returning an object' do
      let(:vfunc_info) do
        get_vfunc_introspection_data 'GIMarshallingTests', 'Object', 'vfunc_return_object_transfer_full'
      end

      it 'returns :pointer' do
        result.must_equal :pointer
      end
    end
  end
end
