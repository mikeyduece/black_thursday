require_relative 'test_helper'
require_relative '../lib/sales_analyst'

class SalesAnalystTest < Minitest::Test
  attr_reader :sa

  def setup
    se = SalesEngine.from_csv({items: "./sa_fixtures/items.csv",
                           merchants: "./sa_fixtures/merchants.csv",
                            invoices: "./sa_fixtures/invoices.csv",
                           customers: "./sa_fixtures/customers.csv",
                        transactions: "./sa_fixtures/transactions.csv",
                       invoice_items: "./sa_fixtures/invoice_items.csv"})
    @sa = SalesAnalyst.new(se)
  end

  def test_it_exists
    assert_instance_of SalesAnalyst, sa
  end

  def test_it_can_calculate_average_items_per_merchant
    assert_equal 1.5, sa.average_items_per_merchant
  end

  def test_it_can_calculate_std_deviation_for_avg_items_per_merchant
    assert_equal 0.44, sa.average_items_per_merchant_standard_deviation
  end

  def test_it_can_determine_merchants_with_high_item_count
    actual = sa.merchants_with_high_item_count
    assert_equal 0, actual.count
  end

  def test_it_can_calculate_average_price_item_price_per_merchant
    actual = sa.average_item_price_for_merchant(12334105)
    assert_instance_of BigDecimal, actual
    assert_equal 0.03, actual
  end

  def test_it_can_avg_the_avgs_of_all_merchant_prices
    actual = sa.average_average_price_per_merchant
    assert_instance_of BigDecimal, actual
    assert_equal 0.05, actual
  end

  def test_it_can_find_golden_items
    assert_equal 1, sa.golden_items.count
  end

  def test_it_can_return_avg_invoices_per_merchant
    actual = sa.average_invoices_per_merchant
    assert_equal 9.25, actual
  end

  def test_it_can_find_avg_invoices_per_merchant_std_dev
    actual = sa.average_invoices_per_merchant_standard_deviation
    assert_equal 3.77, actual
  end

  def test_it_returns_top_performing_merchants
    actual = sa.top_merchants_by_invoice_count
    assert_equal 0, actual.count
  end

  def test_it_can_return_poor_performing_merchants
    actual = sa.bottom_merchants_by_invoice_count
    assert_equal 0, actual.count
  end

  def test_it_finds_top_days_by_invoice_count
    actual = sa.top_days_by_invoice_count
    assert_equal "Monday", actual[0]
    assert_equal 1, actual.count
  end

  def test_it_returns_percentage_of_pending_status
    actual = sa.invoice_status(:pending)
    assert_equal 29.73, actual
  end

  def test_it_can_determine_top_buyers
    assert_equal 16, sa.top_buyers.count
  end

  def test_can_return_less_than_20_buyers
    assert_equal 5, sa.top_buyers(5).count
  end

  def test_returns_customers_fav_merchant
    assert_instance_of Merchant, sa.top_merchant_for_customer(14)
    assert_equal 12334105, sa.top_merchant_for_customer(14).id
  end

  def test_returns_all_items_bought_in_a_year
    assert_instance_of Item, sa.items_bought_in_a_year(14, 2012)[0]
  end
end
