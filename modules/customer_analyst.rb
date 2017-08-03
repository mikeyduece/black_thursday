module CustomerAnalyst

  def ranked(params)
    params.keys.sort_by {|customer_id| params[customer_id].reduce(:+)}.reverse
  end

  def unpaid_invoices
    se.all_invoices.find_all {|invoice| !invoice.is_paid_in_full?}
  end

  # def customers_with_unpaid_invoices
  #   cust_ids = unpaid_invoices.group_by {|invoice| invoice.customer_id}
  #   cust_ids.keys.map {|id| se.customers.find_by_id(id)}
  # end

  def customer(id)
    se.customers.find_by_id(id)
  end

  def customers_invoices(cust_id)
    customer(cust_id).invoices.find_all {|invoice| invoice.is_paid_in_full?}
  end

  def cust_inv_year(cust_id, year)
    customers_invoices(cust_id).find_all do |invoice|
      invoice.created_at.to_s.split("-")[0].to_i == year
    end
  end

  def cust_inv_items(cust_id, year)
    cust_inv_year(cust_id, year).map do |invoice|
      se.invoice_items.find_all_by_invoice_id(invoice.id)
    end.flatten
  end

  def customers_inv_items(cust_inv)
    cust_inv.map {|invoice| invoice.invoice_items}.flatten!
  end

  def customer_item_ids(cust_inv)
    customers_inv_items(cust_inv).group_by {|inv_item| inv_item.item_id}
  end

  def cust_items_count(cust_inv)
    customer_item_ids(cust_inv).keys.reduce({}) do |result, item|
      result[item] = customer_item_ids(cust_inv)[item][0].quantity
      result
    end
  end

  def sorted_items_list(item_ids)
    item_ids.map {|id| se.items.find_by_id(id)}
  end

  def paid_invoices_grpd_by_id
    paid_invoices.group_by {|invoice| invoice.id}
  end

  def cust_inv_items_by_inv_id
    invoices       = paid_invoices_grpd_by_id
    invoices.each_value do |invoices|
      invoices.map! do |invoice|
        invoice.invoice_items
      end.flatten!
    end
  end

  def customer_invoice_by_quantity
    inv_item_ids = cust_inv_items_by_inv_id
    inv_item_ids.keys.reduce({}) do |result, inv|
      result[inv] = inv_item_ids[inv].map {|item|
        item.quantity}.reduce(:+); result
    end
  end

  def sorted_invoices_by_quantity
    cust_invs = customer_invoice_by_quantity
    cust_invs.keys.sort_by {|key| cust_invs[key]}.reverse
  end

  def one_invoice_customers
    invoices  = one_transaction_invoices
    invoices.map {|invoice| invoice.customer}
  end

  def one_time_buyers_invoices
    one_time_buyers.map {|customer| customer.invoices}.flatten.compact
  end
end
