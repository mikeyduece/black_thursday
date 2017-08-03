module InvoiceAnalyst

  def num_invoice_days
    se.all_invoices.map {|invoice| Date::DAYNAMES[invoice.created_at.wday]}
  end

  def invoices_by_day_count
    num_invoice_days.each_with_object(Hash.new(0)) do |day,result|
      result[day] += 1
    end
  end

  def invoice_std_dev_bar
    invoice_day = invoices_by_day_count.values
    avg         = average(invoice_day)
    std_dev     = standard_deviation(invoice_day)
    avg + std_dev
  end

  def statuses
    se.all_invoices.group_by {|invoice| invoice.status}
  end

  def paid_invoices
    se.all_invoices.find_all {|invoice| invoice.is_paid_in_full?}
  end

  def cust_id_grp
    paid_invoices.group_by {|invoice| invoice.customer_id}
  end

  def num_invoices_per_merchant
    se.all_merchants.reduce({}) do |result, merchant|
      result[merchant] = merchant.invoices.count
      result
    end
  end

  def invoice_two_std_dev(info)
    avg     = average(info)
    std_dev = standard_deviation(info) * 2
    avg + std_dev
  end

  def invoice_std_dev(array, merchant, invoices, bar)
    array << merchant if invoices > bar
  end

  def invoice_2_std_dev_below(info)
    avg     = average(info)
    std_dev = standard_deviation(info) * 2
    avg - std_dev
  end

  def invoice_totals(invoice_ids)
    invoice_ids.each_value do |invoices|
      invoices.map! {|invoice| invoice.total}
    end
  end

  def top_invoices
    invoice_ids = paid_invoices.group_by {|invoice| invoice.id}
    inv_totals  = invoice_totals(invoice_ids)
    inv_totals.keys.sort_by {|id| inv_totals[id]}.reverse
  end

  def one_transaction_invoices
    paid_invoices.select {|invoice| invoice if invoice.transactions.count == 1}
  end
end
