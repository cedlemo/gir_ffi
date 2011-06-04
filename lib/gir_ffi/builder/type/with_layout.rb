module GirFFI
  module Builder
    module Type

      # Implements the creation of classes representing types with layout,
      # i.e., :union, :struct, :object.
      module WithLayout
        private

        # TODO: Move to client classes.
        def setup_class
          setup_layout
          setup_constants
          stub_methods
          setup_gtype_getter
        end

        def setup_layout
          spec = layout_specification
          @structklass.class_eval { layout(*spec) }
        end

        def layout_specification
          fields = info.fields

          if fields.empty?
            if parent
              return [:parent, superclass.const_get(:Struct), 0]
            else
              return [:dummy, :char, 0]
            end
          end

          fields.map do |finfo|
            [ finfo.name.to_sym,
              itypeinfo_to_ffitype_for_struct(finfo.field_type),
              finfo.offset ]
          end.flatten
        end
      end
    end
  end
end
