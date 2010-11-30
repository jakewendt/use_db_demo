require 'test_helper'
#require File.expand_path(File.dirname(__FILE__) + "/../test_helper")

class BetaTest < ActiveSupport::TestCase

	test "should create" do
#		puts Beta.connection.current_database
#		assert_only_differences({
#			'Beta.count' => 1,
#			'Beta.next_id' => 1
#		}) {
		assert_difference('Beta.count') {
			assert Beta.create()
		}
	end

end
