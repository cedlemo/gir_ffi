require 'gir_ffi_test_helper'

describe GirFFI::Builders::VFuncBuilder do
  let(:builder) { GirFFI::Builders::VFuncBuilder.new vfunc_info }

  describe "#mapping_method_definition" do
    describe "for a vfunc with only one argument" do
      let(:vfunc_info) {
        get_vfunc_introspection_data "GIMarshallingTests", "Object", "method_int8_in" }

      it "returns a valid mapping method including receiver" do
        expected = <<-CODE.reset_indentation
        def self.call_with_argument_mapping(_proc, _v1, in_)
          _v2 = GIMarshallingTests::Object.wrap(_v1)
          _proc.call(_v2, in_)
        end
        CODE

        builder.mapping_method_definition.must_equal expected
      end
    end

    describe "for a vfunc returning an enum" do
      let(:vfunc_info) {
        get_vfunc_introspection_data "GIMarshallingTests", "Object", "vfunc_return_enum" }

      it "returns a valid mapping method including receiver" do
        skip unless vfunc_info
        expected = <<-CODE.reset_indentation
        def self.call_with_argument_mapping(_proc, _v1)
          _v2 = GIMarshallingTests::Object.wrap(_v1)
          _v3 = _proc.call(_v2)
          _v4 = GIMarshallingTests::Enum.from(_v3)
          return _v4
        end
        CODE

        builder.mapping_method_definition.must_equal expected
      end
    end
  end
end

