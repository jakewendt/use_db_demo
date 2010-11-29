#
#	Add table_status and auto_increment method to your ActiveRecord::Base models
#
#		> script/console
#		Loading development environment (Rails 2.2.2)
#		>> require 'table_status'
#		=> true
#		>> MyModel.auto_increment
#		=> 42
#		>> quit
#
#	I wrote this primarily for testing purposes, although I haven't used it for 
#	that yet.  I wanted to know that a record wasn't added and another removed 
#	to a model.  The standard assert_no_difference wouldn't catch this in 
#	testing when using MyModel.count.
#
#	I may append this to my assert_only_differences.
#
#	This makes tons of assumptions.
#		the table exists.
#		there is a connection.
#		there is a database.
#		that it is MySQL.
#
module TableStatus
	def self.included(base)
		base.extend(ClassMethods)
	end

	module ClassMethods
		def table_status
#			r=ActiveRecord::Base.connection.execute("show table status from #{self.connection.current_database} like '#{self.table_name}'")
			r=self.connection.execute("show table status where name = '#{self.table_name}'")
			##<Mysql::Result:0x1036f0078>	- normal
			if defined?(Mysql) && defined?(Mysql::Result) && r.is_a?(Mysql::Result)
				r.fetch_hash
			else
			#[{"Name"=>"gammas", "Engine"=>"InnoDB", "Version"=>"10", "Row_format"=>"Compact", "Rows"=>"2", "Avg_row_length"=>"8192", "Data_length"=>"16384", "Max_data_length"=>"0", "Index_length"=>"0", "Data_free"=>"30408704", "Auto_increment"=>"3", "Create_time"=>"2010-11-29 11:03:49.0", "Update_time"=>nil, "Check_time"=>nil, "Collation"=>"utf8_unicode_ci", "Checksum"=>nil, "Create_options"=>"", "Comment"=>""}]	- jruby jdbc mysql
				r.first
			end
		end

		def auto_increment
			self.table_status['Auto_increment'].to_i
		end
		alias_method :next_id, :auto_increment
	end
end
ActiveRecord::Base.send( :include, TableStatus )
