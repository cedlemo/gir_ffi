# frozen_string_literal: true
require 'gir_ffi_test_helper'

describe GirFFI::Builders::ReturnValueBuilder do
  let(:var_gen) { GirFFI::VariableNameGenerator.new }
  let(:return_type_info) { GirFFI::ReturnValueInfo.new(type_info, :nothing, false) }
  let(:builder) do
    GirFFI::Builders::ReturnValueBuilder.new(var_gen, return_type_info)
  end

  describe 'for :gint32' do
    let(:type_info) do
      get_introspection_data('GIMarshallingTests',
                             'int_return_min').return_type
    end

    it 'has no statements in #post_conversion' do
      builder.post_conversion.must_equal []
    end

    it 'returns the result of the c function directly' do
      builder.capture_variable_name.must_equal '_v1'
      builder.return_value_name.must_equal '_v1'
    end
  end

  describe 'for :struct' do
    let(:type_info) do
      get_method_introspection_data('GIMarshallingTests',
                                    'BoxedStruct',
                                    'returnv').return_type
    end

    it 'wraps the result in #post_conversion' do
      builder.capture_variable_name.must_equal '_v1'
      builder.post_conversion.must_equal ['_v2 = GIMarshallingTests::BoxedStruct.wrap(_v1)']
    end

    it 'returns the wrapped result' do
      builder.capture_variable_name.must_equal '_v1'
      builder.return_value_name.must_equal '_v2'
    end
  end

  describe 'for :union' do
    let(:type_info) do
      get_method_introspection_data('GIMarshallingTests',
                                    'Union',
                                    'returnv').return_type
    end

    it 'wraps the result in #post_conversion' do
      builder.capture_variable_name.must_equal '_v1'
      builder.post_conversion.must_equal ['_v2 = GIMarshallingTests::Union.wrap(_v1)']
    end

    it 'returns the wrapped result' do
      builder.capture_variable_name.must_equal '_v1'
      builder.return_value_name.must_equal '_v2'
    end
  end

  describe 'for :interface' do
    let(:type_info) do
      get_method_introspection_data('Gio',
                                    'File',
                                    'new_for_commandline_arg').return_type
    end

    it 'wraps the result in #post_conversion' do
      builder.capture_variable_name.must_equal '_v1'
      builder.post_conversion.must_equal ['_v2 = Gio::File.wrap(_v1)']
    end

    it 'returns the wrapped result' do
      builder.capture_variable_name.must_equal '_v1'
      builder.return_value_name.must_equal '_v2'
    end
  end

  describe 'for :object' do
    let(:type_info) do
      get_method_introspection_data('GIMarshallingTests',
                                    'Object',
                                    'full_return').return_type
    end

    it 'wraps the result in #post_conversion' do
      builder.capture_variable_name.must_equal '_v1'
      builder.post_conversion.must_equal ['_v2 = GIMarshallingTests::Object.wrap(_v1)']
    end

    it 'returns the wrapped result' do
      builder.capture_variable_name.must_equal '_v1'
      builder.return_value_name.must_equal '_v2'
    end
  end

  describe 'for :strv' do
    let(:type_info) do
      get_method_introspection_data('GLib',
                                    'KeyFile',
                                    'get_locale_string_list').return_type
    end

    it 'wraps the result in #post_conversion' do
      builder.capture_variable_name.must_equal '_v1'
      builder.post_conversion.must_equal ['_v2 = GLib::Strv.wrap(_v1)']
    end

    it 'returns the wrapped result' do
      builder.capture_variable_name.must_equal '_v1'
      builder.return_value_name.must_equal '_v2'
    end
  end

  describe 'for :zero_terminated' do
    let(:type_info) do
      get_method_introspection_data('GLib',
                                    'Variant',
                                    'dup_bytestring').return_type
    end
    before do
      skip unless type_info.zero_terminated?
    end

    it 'wraps the result in #post_conversion' do
      builder.capture_variable_name.must_equal '_v1'
      builder.post_conversion.must_equal ['_v2 = GirFFI::ZeroTerminated.wrap(:guint8, _v1)']
    end

    it 'returns the wrapped result' do
      builder.capture_variable_name.must_equal '_v1'
      builder.return_value_name.must_equal '_v2'
    end
  end

  describe 'for :byte_array' do
    let(:type_info) do
      get_introspection_data('GIMarshallingTests',
                             'bytearray_full_return').return_type
    end

    it 'wraps the result in #post_conversion' do
      builder.capture_variable_name.must_equal '_v1'
      builder.post_conversion.must_equal ['_v2 = GLib::ByteArray.wrap(_v1)']
    end

    it 'returns the wrapped result' do
      builder.capture_variable_name.must_equal '_v1'
      builder.return_value_name.must_equal '_v2'
    end
  end

  describe 'for :ptr_array' do
    let(:type_info) do
      get_introspection_data('GIMarshallingTests',
                             'gptrarray_utf8_none_return').return_type
    end

    it 'wraps the result in #post_conversion' do
      builder.capture_variable_name.must_equal '_v1'
      builder.post_conversion.must_equal ['_v2 = GLib::PtrArray.wrap(:utf8, _v1)']
    end

    it 'returns the wrapped result' do
      builder.capture_variable_name.must_equal '_v1'
      builder.return_value_name.must_equal '_v2'
    end
  end

  describe 'for :glist' do
    let(:type_info) do
      get_introspection_data('GIMarshallingTests',
                             'glist_int_none_return').return_type
    end

    it 'wraps the result in #post_conversion' do
      builder.capture_variable_name.must_equal '_v1'
      builder.post_conversion.must_equal ['_v2 = GLib::List.wrap(:gint32, _v1)']
    end

    it 'returns the wrapped result' do
      builder.capture_variable_name.must_equal '_v1'
      builder.return_value_name.must_equal '_v2'
    end
  end

  describe 'for :gslist' do
    let(:type_info) do
      get_introspection_data('GIMarshallingTests',
                             'gslist_int_none_return').return_type
    end

    it 'wraps the result in #post_conversion' do
      builder.capture_variable_name.must_equal '_v1'
      builder.post_conversion.must_equal ['_v2 = GLib::SList.wrap(:gint32, _v1)']
    end

    it 'returns the wrapped result' do
      builder.capture_variable_name.must_equal '_v1'
      builder.return_value_name.must_equal '_v2'
    end
  end

  describe 'for :ghash' do
    let(:type_info) do
      get_introspection_data('GIMarshallingTests',
                             'ghashtable_int_none_return').return_type
    end

    it 'wraps the result in #post_conversion' do
      builder.capture_variable_name.must_equal '_v1'
      builder.post_conversion.must_equal ['_v2 = GLib::HashTable.wrap([:gint32, :gint32], _v1)']
    end

    it 'returns the wrapped result' do
      builder.capture_variable_name.must_equal '_v1'
      builder.return_value_name.must_equal '_v2'
    end
  end

  describe 'for :array' do
    let(:type_info) do
      get_introspection_data('GIMarshallingTests',
                             'garray_int_none_return').return_type
    end

    it 'wraps the result in #post_conversion' do
      builder.capture_variable_name.must_equal '_v1'
      builder.post_conversion.must_equal ['_v2 = GLib::Array.wrap(:gint32, _v1)']
    end

    it 'returns the wrapped result' do
      builder.capture_variable_name.must_equal '_v1'
      builder.return_value_name.must_equal '_v2'
    end
  end

  describe 'for :error' do
    let(:type_info) do
      get_introspection_data('GIMarshallingTests',
                             'gerror_return').return_type
    end

    it 'wraps the result in #post_conversion' do
      builder.capture_variable_name.must_equal '_v1'
      builder.post_conversion.must_equal ['_v2 = GLib::Error.wrap(_v1)']
    end

    it 'returns the wrapped result' do
      builder.capture_variable_name.must_equal '_v1'
      builder.return_value_name.must_equal '_v2'
    end
  end

  describe 'for :c' do
    describe 'with fixed size' do
      let(:type_info) do
        get_introspection_data('GIMarshallingTests',
                               'array_fixed_int_return').return_type
      end

      it 'converts the result in #post_conversion' do
        builder.capture_variable_name.must_equal '_v1'
        builder.post_conversion.must_equal ['_v2 = GirFFI::SizedArray.wrap(:gint32, 4, _v1)']
      end

      it 'returns the wrapped result' do
        builder.capture_variable_name.must_equal '_v1'
        builder.return_value_name.must_equal '_v2'
      end
    end

    describe 'with separate size parameter' do
      let(:length_argument) { Object.new }
      let(:type_info) do
        get_method_introspection_data('GIMarshallingTests',
                                      'Object',
                                      'method_array_return').return_type
      end

      before do
        allow(length_argument).to receive(:post_converted_name).and_return 'bar'
        builder.length_arg = length_argument
      end

      it 'converts the result in #post_conversion' do
        builder.capture_variable_name.must_equal '_v1'
        builder.post_conversion.must_equal ['_v2 = GirFFI::SizedArray.wrap(:gint32, bar, _v1)']
      end

      it 'returns the wrapped result' do
        builder.capture_variable_name.must_equal '_v1'
        builder.return_value_name.must_equal '_v2'
      end
    end
  end

  describe 'for :utf8' do
    let(:type_info) do
      get_introspection_data('GIMarshallingTests', 'utf8_full_return').return_type
    end

    it 'converts the result in #post_conversion' do
      builder.capture_variable_name.must_equal '_v1'
      builder.post_conversion.must_equal ['_v2 = _v1.to_utf8']
    end

    it 'returns the converted result' do
      builder.capture_variable_name.must_equal '_v1'
      builder.return_value_name.must_equal '_v2'
    end
  end

  describe 'for :void pointer' do
    let(:callback_info) do
      get_introspection_data('GIMarshallingTests', 'CallbackIntInt')
    end
    let(:type_info) { callback_info.args[1].argument_type }

    before do
      skip unless callback_info
    end

    it 'has no statements in #post_conversion' do
      builder.post_conversion.must_equal []
    end

    it 'returns the result of the c function directly' do
      builder.capture_variable_name.must_equal '_v1'
      builder.return_value_name.must_equal '_v1'
    end
  end

  describe 'for :void' do
    let(:type_info) do
      get_method_introspection_data('Regress', 'TestObj', 'null_out').return_type
    end

    it 'has no statements in #post_conversion' do
      builder.post_conversion.must_equal []
    end

    it 'marks itself as irrelevant' do
      builder.relevant?.must_equal false
    end

    it 'returns nothing' do
      builder.return_value_name.must_be_nil
    end
  end

  describe 'for a closure argument' do
    let(:type_info) do
      get_introspection_data('Regress', 'TestCallbackUserData').args[0].argument_type
    end

    before do
      builder.closure = true
    end

    it 'fetches the stored object in #post_conversion' do
      builder.capture_variable_name.must_equal '_v1'
      builder.post_conversion.must_equal ['_v2 = GirFFI::ArgHelper::OBJECT_STORE.fetch(_v1)']
    end

    it 'returns the stored object' do
      builder.capture_variable_name.must_equal '_v1'
      builder.return_value_name.must_equal '_v2'
    end
  end

  describe 'for a skipped return value' do
    let(:type_info) do
      get_method_introspection_data('Regress', 'TestObj', 'skip_return_val').return_type
    end
    let(:return_type_info) { GirFFI::ReturnValueInfo.new(type_info, :nothing, true) }

    it 'has no statements in #post_conversion' do
      builder.post_conversion.must_equal []
    end

    it 'marks itself as irrelevant' do
      builder.relevant?.must_equal false
    end

    it 'returns nothing' do
      builder.return_value_name.must_be_nil
    end
  end
end
