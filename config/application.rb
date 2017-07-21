require 'active_record'
require 'state_machines-activerecord'

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => ':memory:'

require_relative '../app/models/address'
require_relative '../app/models/collection'
require_relative '../app/models/customer'
require_relative '../app/models/purchase'
