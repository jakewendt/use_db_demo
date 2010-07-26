require 'test_helper'
#require File.expand_path(File.dirname(__FILE__) + "/../test_helper")

class NormalTest < ActiveSupport::TestCase

	test "should create" do
#		puts Normal.connection.current_database
		assert_only_differences({
			'Normal.count' => 1,
			'Normal.next_id' => 1
		}) {
			assert Normal.create()
		}
	end

end
