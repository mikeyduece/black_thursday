require 'time'
require 'bigdecimal'

class InvoiceItem

  attr_reader :id,
              :item_id,
              :invoice_id,
              :quantity,
              :unit_price,
              :created_at,
              :updated_at

  def initialize(hash, repo = nil)
    @id = hash[:id]
    @item_id = hash[:item_id]
    @invoice_id = hash[:invoice_id]
    @quantity = hash[:quantity]
    @unit_price = BigDecimal.new(hash[:unit_price])
    @created_at = Time.parse(hash[:created_at].to_s)
    @updated_at = Time.parse(hash[:updated_at].to_s)
  end







end
