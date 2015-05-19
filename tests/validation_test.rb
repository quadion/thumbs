require 'minitest/reporters'
require "minitest/test"
require 'minitest/autorun'
require "active_support"
require 'json'

ActiveSupport.test_order = :sorted

class MyTest < ActiveSupport::TestCase

  setup do
    @json = JSON.parse(IO.read(File.new(File.expand_path('../../list.json', __FILE__))), {:symbolize_names => true})
  end

  test 'JSON file parses properly' do
    assert true
  end
  
  test 'JSON has a top level :thumbs key' do
    assert @json[:thumbs]
  end
  
  test ':thumbs key contains an Array' do
    assert @json[:thumbs].kind_of? Array
  end
  
  test 'each entry has a name, version and votes' do
    @json[:thumbs].each_with_index do |item, index|
      assert item[:name], "Entry #{index} doesn't have a name"
      assert item[:version], "Entry #{index} doesn't have a name"
      assert item[:votes], "Entry #{index} doesn't have a name"
      assert item[:votes].kind_of?(Array), "Votes for entry #{index} must be an Array"
    end
  end
  
  test 'votes have a type of :up or :down and a voter' do
    @json[:thumbs].each do |entry|
      entry[:votes].each_with_index do |vote, index|
        assert vote[:type], "Vote #{index} for entry #{entry[:name]} doesn't have a type"
        assert [:up, :down].include?(vote[:type].to_sym), "Vote #{index} for entry #{entry[:name]} is invalid (not 'up' or 'down')"
        assert vote[:voter], "Vote #{index} for entry #{entry[:name]} doesn't have a voter"
        assert vote[:voter].kind_of?(String), "Vote #{index} for entry #{entry[:name]} is not a String"
      end
    end
  end

end