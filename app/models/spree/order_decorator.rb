module Spree
  Order.class_eval do
    after_update :clean_inventory_units

    def clean_inventory_units
      if state == 'delivery'
        units = inventory_units.where(shipment: nil)
        InventoryUnit.destroy(units.ids) if units.any?
      end
    end
  end
end

