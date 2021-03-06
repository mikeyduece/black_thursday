require_relative 'sales_engine'
require_relative 'rick_roll'

class SalesAnalyst < RickRoll
  attr_reader :se

  def initialize(se)
    @se = se
  end

  def average_items_per_merchant
    (se.all_items.count.to_f / se.all_merchants.count.to_f).round(2)
  end

  def average_items_per_merchant_standard_deviation
    standard_deviation(num_items_per_merchant.values).round(2)
  end

  def merchants_with_high_item_count
    bar = one_standard_deviation_bar
    high_sell = []
    num_items_per_merchant.each do |k,v|
      high_sell << k if v > bar
    end
    high_sell
  end

  def average_item_price_for_merchant(id)
    average(merchant_items_prices(id))
  end

  def average_average_price_per_merchant
    avg = []
    merchant_id_item_group.each do |key,value|
      avg << value.map {|item| item.unit_price}.reduce(:+) / value.count
    end
    average(avg)
  end

  def golden_items
    gold = []
    se.all_items.map {|item| item_std_dev(gold, item)}
    gold
  end

  def average_invoices_per_merchant
    (se.all_invoices.count.to_f / se.all_merchants.count.to_f).round(2)
  end

  def average_invoices_per_merchant_standard_deviation
    standard_deviation(num_invoices_per_merchant.values).round(2)
  end

  def top_merchants_by_invoice_count
    top = []
    bar = invoice_two_std_dev(num_invoices_per_merchant.values)
    num_invoices_per_merchant.each do |merchant, invoices|
      invoice_std_dev(top, merchant, invoices, bar)
    end
    top
  end

  def bottom_merchants_by_invoice_count
    bottom = []
    bar    = invoice_2_std_dev_below(num_invoices_per_merchant.values)
    num_invoices_per_merchant.each do |merchant, invoices|
      bad_merchants(bottom, merchant, invoices, bar)
    end
    bottom
  end

  def top_days_by_invoice_count
    top_inv = []
    invoices_by_day_count.each do |day, number|
      top_inv << day if number > invoice_std_dev_bar.round(0)
    end
    top_inv
  end

  def invoice_status(status)
    ((statuses[status].count).to_f /
      (se.all_invoices.count).to_f * 100).round(2)
  end

  def top_buyers(num=20)
    totals          = cust_id_grp.each_value do |invoices|
                        invoices.map! {|invoice| invoice.total}
                      end
    customer_list   = ranked(totals).map {|id| se.customers.find_by_id(id)}
    customer_list[0...num]
  end

  def top_merchant_for_customer(id)
    max_quan = customer(id).invoices.max_by do |invoice|
      invoice.quantity
    end
    invoice_max = se.invoices.find_by_id(max_quan.id)
    se.merchants.find_by_id(invoice_max.merchant_id)
  end

  def items_bought_in_year(cust_id, year)
    cust_inv_items(cust_id, year).map do |inv_item|
      se.items.find_by_id(inv_item.item_id)
    end
  end

  def highest_volume_items(id)
    cust_inv = customer(id).invoices
    cust_items_sorted = cust_items_count(cust_inv).keys.select do |key|
      cust_items_count(cust_inv)[key] == cust_items_count(cust_inv).values.max
    end
    sorted_items_list(cust_items_sorted)
  end

  def customers_with_unpaid_invoices
    cust_ids = unpaid_invoices.group_by {|invoice| invoice.customer_id}
    cust_ids.keys.map {|id| se.customers.find_by_id(id)}
  end

  def best_invoice_by_revenue
    se.invoices.find_by_id(top_invoices[0])
  end

  def best_invoice_by_quantity
    cust_inv_sorted = sorted_invoices_by_quantity
    se.invoices.find_by_id(cust_inv_sorted[1])
  end

  def one_time_buyers
    customers = one_invoice_customers
    customers.select {|customer| customer if customer.invoices.count == 1}
  end

  def one_time_buyers_top_items
    id  = items_group_by_ids
    [se.items.find_by_id(id[0])]
  end

end
