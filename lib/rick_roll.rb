require_relative '../modules/customer_analyst'
require_relative '../modules/invoice_analyst'
require_relative '../modules/items_analyst'
require_relative '../modules/merchant_analyst'
require_relative '../modules/stats'

class RickRoll
  include CustomerAnalyst
  include InvoiceAnalyst
  include ItemsAnalyst
  include MerchantAnalyst
  include Stats

end
