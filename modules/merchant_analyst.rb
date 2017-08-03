module MerchantAnalyst

  def one_standard_deviation_bar
    avg     = average_items_per_merchant
    std_dev = average_items_per_merchant_standard_deviation
    avg + std_dev
  end

  def num_items_per_merchant
    se.all_merchants.reduce({}) do |result, merchant|
      result[merchant] = merchant.items.count
      result
    end
  end

  def merchant_items_prices(id)
    merchant = se.merchants.find_by_id(id)
    merchant.items.map {|item| item.unit_price}
  end

  def merchant_id_item_group
    se.all_items.group_by {|item| item.merchant_id}
  end

  def bad_merchants(array, merchant, invoices, bar)
    array << merchant if invoices < bar
  end
end
