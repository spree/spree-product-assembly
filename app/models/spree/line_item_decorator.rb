Spree::LineItem.class_eval do

  validate :validate_quantity_and_stock

  private

    def validate_quantity_and_stock
      unless has_quantity?
        errors.add(:quantity, I18n.t("validation.must_be_non_negative"))
      end

      unless sufficient_inventory_for_order?
        errors.add(:quantity, I18n.t("validation.is_too_large") + " (#{self.variant.name})")
      end

      return unless variant
    end

    def has_quantity?
      quantity && quantity >= 0
    end

    def sufficient_inventory_for_order?
      return true if Spree::Config[:allow_backorders]
      return true unless Spree::Config[:track_inventory_levels]
      if product.assembly?
        product.parts.each do |part|
          return false if part.on_hand < 1
        end
      end
      true
    end

    # Overriden from Spree core to properly manage inventory units when item
    # is a product bundle
    def update_inventory
      return true unless order.completed?

      if new_record?
        increase_inventory_with_assembly(quantity)
      elsif old_quantity = self.changed_attributes['quantity']
        if old_quantity < quantity
          increase_inventory_with_assembly(quantity - old_quantity)
        elsif old_quantity > quantity
          decrease_inventory_with_assembly(old_quantity - quantity)
        end
      end
    end

    def increase_inventory_with_assembly(number)
      if product.assembly?
        product.parts.each{ |part| Spree::InventoryUnit.increase(order, part, number * product.count_of(part)) }
      else
        Spree::InventoryUnit.increase(order, variant, number)
      end
    end

    def decrease_inventory_with_assembly(number)
      if product.assembly?
        product.parts.each{ |part| Spree::InventoryUnit.decrease(order, part, number * product.count_of(part)) }
      else
        Spree::InventoryUnit.increase(order, variant, number)
      end
    end
end
