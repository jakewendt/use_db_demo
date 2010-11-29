class Test::Unit::TestCase

	cattr_accessor :ignore_differences
	cattr_accessor :add_differences

	self.ignore_differences = []
	self.add_differences = {}		#	I haven't tested this yet but should work in theory.

	#	This is excessive!  But I love it!
	#	Set all these defaults here then when you call
	#	assert_only_differences() {
	#		do_something_stupid()
	#	}
	#	it will ensure that nothing was added (net count)
	#	(if something was added and something else was removed
	#		you'll never know.)
	def assert_only_differences(differences={}, &block)
		all_differences = default_differences.merge(differences)
		assert_differences(all_differences.to_a) do
			yield
		end
	end

private

	def default_differences()
		#	generate a big hash containing model names and the
		#	default expected change (usually 0).
		#	ex.  { 'News.count' => 0, 'User.count' => 0 }
		#	using @@ limits the call to only once as one might expect inside autotest 
		#	(but once for each units/functionals/integrations with rake test)
		@@default_differences ||= (
			ddhash = {}
			Object.subclasses_of(ActiveRecord::Base).each do |ar|
#
#	OK OK OK, when using use_db
#	this loop includes TestModelAlphaForClone, TestModelAlphaForPurge, TestModelAlphaForDumpStructure
#	after the first loop.  These AR's are "connected", but not "active"
#
begin
				if ar.connection.active? and ar.table_exists? and !ignore_differences.include?(ar.to_s)
					ddhash["#{ar.name}.count"] = 0
					ddhash["#{ar.name}.next_id"] = 0
				end
rescue ActiveRecord::ConnectionNotEstablished
end
			end
			ddhash.merge(add_differences)
		)
	end

	def assert_differences(differences=[], &block)
		this_diff = differences.pop
		if this_diff.blank?
			yield
		else
			assert_difference( this_diff[0], this_diff[1], "#{this_diff[0]} should've changed by #{this_diff[1]}" ) do
				assert_differences(differences) { yield }
			end
		end
	end

end
