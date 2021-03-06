require 'test_helper'

class LoadOnceTest < BaseTest
  include Mongoid::FixtureSet::TestHelper
  self.fixture_path = 'test/load_once_fixtures'
  self.load_fixtures_once = true

  class_attribute :count
  self.count = 0

  module FixtureLoadCount
    def count
      LoadOnceTest.count += 1
    end
  end
  Mongoid::FixtureSet.context_class.send :include, FixtureLoadCount

  def teardown
  end

  def count_equal_1
    assert_equal 1, self.class.count
    begin
      tests(:test1)
      assert true
    rescue => e
      assert false, "#{e}\n#{e.backtrace.join("\n")}"
    end
  end

  5.times do |i|
    alias_method "test_load_once_#{i}", :count_equal_1
  end
end

