require './test/test_helper'
require_relative '../lib/item_repo'

class ItemRepoTest < Minitest::Test
  attr_reader :ir

  def setup
   @ir = ItemRepo.new("./data/items.csv")
  end

  def test_find_all_items
   assert_equal 1367, ir.all.count
  end

  def test_find_by_name
    assert_equal Item, ir.find_by_name("Custom Hand Made Miniature Bicycle").class
    assert_nil ir.find_by_id(5)
  end

end

#   def test_find_all_with_description
#     assert_equal
#
# end
