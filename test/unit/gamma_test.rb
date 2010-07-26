require 'test_helper'
#require File.expand_path(File.dirname(__FILE__) + "/../test_helper")

class GammaTest < ActiveSupport::TestCase

	test "should create" do
#		puts Gamma.connection.current_database
		assert_only_differences({
			'Gamma.count' => 1,
			'Gamma.next_id' => 1
		}) {
			assert Gamma.create()
		}
	end

end
