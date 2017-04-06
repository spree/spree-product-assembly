module Spree
  module Stock
    Coordinator.class_eval do

      private

      def unallocated_inventory_units
        if inventory_units.map(&:id).include?(nil)
          allocated_inventory_units.each do |allocated|
            inventory_units.each_with_index do |unit, index|
              inventory_units.delete_at(index) if should_delete_item?(allocated, unit)
            end
          end
          inventory_units
        else
          inventory_units - allocated_inventory_units
        end
      end

      def should_delete_item?(allocated, unit)
        allocated.line_item_id == unit.line_item_id && allocated.variant_id == unit.variant_id
      end
    end
  end
end
