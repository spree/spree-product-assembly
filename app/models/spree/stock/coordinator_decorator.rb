module Spree
  module Stock
    Coordinator.class_eval do
      attr_reader :allocated_inventory_units

      def initialize(order, inventory_units = nil)
        @order = order
        @inventory_units = inventory_units || InventoryUnitBuilder.new(order).units
        @allocated_inventory_units = []
      end

      def build_packages(packages = Array.new)
        stock_locations_with_requested_variants.each do |stock_location|
          packer = build_packer(stock_location, unallocated_inventory_units)
          packages += packer.packages
          @allocated_inventory_units += packer.allocated_inventory_units
        end

        packages
      end

      private

      def unallocated_inventory_units
        if inventory_units.map(&:id).include?(nil)
          allocated_inventory_units.each do |allocated|
            inventory_units.each_with_index do |unit, index|
              if should_delete_item?(allocated, unit)
                inventory_units.delete_at(index)
                break
              end
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
