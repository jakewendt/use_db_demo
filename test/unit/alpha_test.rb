require 'test_helper'
#require File.expand_path(File.dirname(__FILE__) + "/../test_helper")

class AlphaTest < ActiveSupport::TestCase

	test "should create" do
#		puts Alpha.connection.current_database
		assert_only_differences({
			'Alpha.count' => 1,
			'Alpha.next_id' => 1
		}) {
			assert Alpha.create()
		}
	end

end
