require_relative 'test_helper'
require_relative '../lib/sales_engine'

class SalesEngineTest < Minitest::Test
  attr_reader :se

  def setup
    @se = SalesEngine.from_csv({items: "./data/item_fixtures.csv",
                            merchants: "./data/merchant_fixtures.csv",
                             invoices: "./data/invoice_fixtures.csv",
                            customers: "./data/customer_fixtures.csv",
                         transactions: "./data/transaction_fixtures.csv",
                        invoice_items: "./data/invoice_item_fixtures.csv"})
  end

  def test_it_exists
    assert_instance_of SalesEngine, se
  end

  def test_engine_can_find_merchant_by_name
    mr = se.merchants
    merchant = mr.find_by_name("MiniatureBikez")
    assert_instance_of Merchant, merchant
    assert_equal "MiniatureBikez", merchant.name
  end

  def test_engine_can_find_item_by_name
    ir   = se.items
    item = ir.find_by_name("Glitter scrabble frames")
    assert_instance_of Item, item
    assert_equal "Glitter scrabble frames", item.name
  end

  def test_it_can_find_all_items_of_particular_merchant
    merchant = se.merchants.find_by_id(12334185)
    assert_equal 1, merchant.items.count
  end

  def test_it_can_find_merchant_by_item_id
    item = se.items.find_by_id(263395237)
    assert_instance_of Merchant, item.merchant
  end

  def test_it_can_get_all_invoices_by_merch_id
    merchant = se.merchants.find_by_id(12334269)
    assert_instance_of Invoice, merchant.invoices[0]
  end

  def test_it_can_get_merchant_from_invoice_id
    invoice = se.invoices.find_by_id(4)
    assert_instance_of Merchant, invoice.merchant
  end

  def test_it_can_return_all_items_for_an_invoice
    invoice = se.invoices.find_by_id(20)
    assert_equal 4, invoice.items.count
  end

end
