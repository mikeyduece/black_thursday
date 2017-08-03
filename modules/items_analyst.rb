module ItemsAnalyst

  def item_prices
    se.all_items.map {|item| item.unit_price}
  end

  def item_two_std_dev(info)
    avg     = average(info)
    std_dev = standard_deviation(info) * 2
    avg + std_dev
  end

  def item_std_dev(array, item)
    if item.unit_price > item_two_std_dev(item_prices)
      array << item
    end
  end

  def one_time_customer_items
    cust_invs = one_time_buyers_invoices
    items = cust_invs.map {|invoice| invoice.items}.flatten.compact
    items.group_by {|item| item.id}
  end

  def items_group_by_ids
    items_grp = one_time_customer_items
    items_grp.max_by do |key|
      items_grp[key[0]].count
    end
  end


end
