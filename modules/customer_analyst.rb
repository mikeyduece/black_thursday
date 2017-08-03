module CustomerAnalyst
  def ranked(params)
    params.keys.sort_by {|customer_id| params[customer_id].reduce(:+)}.reverse
  end

  def unpaid_invoices
    se.all_invoices.find_all {|invoice| !invoice.is_paid_in_full?}
  end

  def customers_with_unpaid_invoices
    cust_ids = unpaid_invoices.group_by {|invoice| invoice.customer_id}
    cust_ids.keys.map {|id| se.customers.find_by_id(id)}
  end

end
