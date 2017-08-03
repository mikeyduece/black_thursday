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

end
