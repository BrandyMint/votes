require "votes/version"
require "active_record"

require 'votes/active_record_ext'
ActiveRecord::Base.extend Votes::ActiveRecordExt

require 'votes/engine' if defined? Rails