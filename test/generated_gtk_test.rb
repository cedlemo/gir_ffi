require File.expand_path('test_helper.rb', File.dirname(__FILE__))

# Tests generated methods and functions in the Gtk namespace.
class GeneratedGtkTest < Test::Unit::TestCase
  context "In the generated Gtk module" do
    context "a Gtk::Builder instance" do
      setup do
	@builder = Gtk::Builder.new
	@spec = '
	<interface>
	<object class="GtkButton" id="foo">
	<signal handler="on_button_clicked" name="clicked"/>
	</object>
	</interface>
	'
      end

      should "load spec" do
	assert_nothing_raised { @builder.add_from_string @spec, @spec.length }
      end

      context "its #get_object method" do
	should "return objects of the proper class" do
	  @builder.add_from_string @spec, @spec.length
	  o = @builder.get_object "foo"
	  assert_instance_of Gtk::Button, o
	end
      end

      context "its #connect_signals_full method" do
	setup do
	  @builder.add_from_string @spec, @spec.length
	end
	should "pass arguments correctly" do
	  aa = nil
	  @builder.connect_signals_full Proc.new {|*args| aa = args}, nil
	  b, o, sn, hn, co, f, ud = aa
	  assert_instance_of Gtk::Builder, b
	  assert_equal b.to_ptr, @builder.to_ptr
	  assert_instance_of Gtk::Button, o
	  assert_equal "clicked", sn
	  assert_equal "on_button_clicked", hn
	  assert_equal nil, co
	  assert_equal :after, f
	  assert_equal nil, ud
	end
      end
    end
  end
end

