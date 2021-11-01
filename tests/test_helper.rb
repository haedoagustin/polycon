require 'simplecov'
SimpleCov.start do
  add_filter(/.*_test\.rb$/)
end

require "minitest/autorun"
require "minitest/reporters"

Minitest::Reporters.use!

require 'configuration'
require 'data_management'

DataManagement::Managers::FileManager.use!(db_name: '.testing_polycon', is_testing: true)
