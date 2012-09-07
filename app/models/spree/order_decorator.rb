Spree::Order.class_eval do

  # Updated restock and unstock item to include assemblies #
  def restock_items!
    line_items.each do |line_item|

      if line_item.variant.product.parts.present?
        line_item.variant.product.parts.each do |line_variant|
          product = line_item.product
          Spree::InventoryUnit.decrease(self, line_variant, line_item.quantity * product.count_of(line_variant))
        end
      else
        Spree::InventoryUnit.decrease(self, line_item.variant, line_item.quantity)
      end

    end
  end

  def unstock_items!
    line_items.each do |line_item|
      if line_item.variant.product.parts.present?
        line_item.variant.product.parts.each do |line_variant|
          product = line_item.product
          Spree::InventoryUnit.increase(self, line_variant, line_item.quantity * product.count_of(line_variant))
        end
      else
        Spree::InventoryUnit.increase(self, line_item.variant, line_item.quantity)
      end
    end
  end

end

