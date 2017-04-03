module Spree
  module Stock
    Prioritizer.class_eval do

      private

      def hash_item(item)
        shipment = item.inventory_unit.shipment
        inventory_unit = item.inventory_unit
        if shipment.present?
          inventory_unit.hash ^ shipment.hash
        else
          inventory_unit.hash
        end
      end
    end
  end
end
