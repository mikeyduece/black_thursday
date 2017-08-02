require 'csv'
require_relative 'customer'

class CustomerRepo
  attr_reader :customers, :parent

  def initialize(filename, se=nil)
    @customers = {}
    open_file(filename)
    @parent    = se
  end

  def open_file(filename)
    CSV.foreach filename, headers: true, header_converters: :symbol do |row|
      customers[row[:id].to_i] = Customer.new(row, self)
    end
  end

  def all
    customers.values
  end

  def invoices(id)
    parent.invoices_of_customer(id)
  end

  def find_by_id(id)
    customers[id]
  end

  def find_all_by_first_name(f_name)
    all.find_all {|cust| cust.first_name.downcase.include?(f_name.downcase)}
  end

  def find_all_by_last_name(l_name)
    all.find_all {|cust| cust.last_name.downcase.include?(l_name.downcase)}
  end

  def customers_merchants(id)
    parent.customers_merchants(id)
  end

  # def get_invoice_items(id)
  #   parent.invoice_items.find_all_by_invoice_id(id)
  # end
end
