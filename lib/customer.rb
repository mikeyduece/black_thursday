class Customer
  attr_reader :id, :first_name, :last_name,
              :created_at, :updated_at, :parent

  def initialize(params, repo=nil)
    @id         = params[:id].to_i
    @first_name = params[:first_name].to_s
    @last_name  = params[:last_name].to_s
    @created_at = Time.parse(params[:created_at].to_s)
    @updated_at = Time.parse(params[:updated_at].to_s)
    @parent     = repo
  end

  def merchants
    parent.customers_merchants(id)
  end

  def invoices
    parent.invoices(id)
  end

  # def get_invoice_items
  #   invoices.map do |invoice|
  #     parent.get_invoice_items(invoice.id)
  #   end
  # end
  #
  # def get_invoice_quantity
  #   get_invoice_items.max_by do |invoice_item|
  #     require "pry"; binding.pry
  #     invoice_item.quantity
  #   end
  # end



end
