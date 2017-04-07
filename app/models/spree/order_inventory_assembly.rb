module Spree
  # This class has basically the same functionality of Spree core OrderInventory
  # except that it takes account of bundle parts and properly creates and
  # removes inventory unit for each parts of a bundle
  class OrderInventoryAssembly < OrderInventory
    attr_reader :product

    def initialize(line_item)
      @order = line_item.order
      @line_item = line_item
      @product = line_item.product
      @variant = line_item.variant
    end

    def verify(shipment = nil)
      if order.completed? || shipment.present?
        line_item.quantity_by_variant.each do |part, total_parts|
          existing_parts = line_item.inventory_units.where(variant: part).count

          self.variant = part

          verify_parts(shipment, total_parts, existing_parts)
        end
      end
    end

    private

    def add_to_shipment(shipment, quantity)
      units = shipment.inventory_units
      if variant.should_track_inventory?
        on_hand, back_order = shipment.stock_location.fill_status(variant, quantity)

        on_hand.times { units << set_up_invetory_unit('on_hand', variant, order, line_item) }
        back_order.times { units << set_up_invetory_unit('backordered', variant, order, line_item) }
      else
        quantity.times { units << set_up_invetory_unit('on_hand', variant, order, line_item) }
      end

      shipment.inventory_units = units
      shipment.save

      # adding to this shipment, and removing from stock_location
      if order.completed?
        shipment.stock_location.unstock(variant, quantity, shipment)
      end

      quantity
    end

    def set_up_invetory_unit(state, variant, order, line_item)
      InventoryUnit.new(state: state, variant_id: variant.id, order_id: order.id, line_item_id: line_item.id)
    end

    def verify_parts(shipment, total_parts, existing_parts)
      if existing_parts < total_parts
        verifiy_add_to_shipment(shipment, total_parts, existing_parts)
      elsif existing_parts > total_parts
        verify_remove_from_shipment(shipment, total_parts, existing_parts)
      end
    end

    def verifiy_add_to_shipment(shipment, total_parts, existing_parts)
      shipment = determine_target_shipment unless shipment
      add_to_shipment(shipment, total_parts - existing_parts)
    end

    def verify_remove_from_shipment(shipment, total_parts, existing_parts)
      quantity = existing_parts - total_parts

      if shipment.present?
        remove_from_shipment(shipment, quantity)
      else
        order.shipments.each do |shpment|
          break if quantity == 0
          quantity -= remove_from_shipment(shpment, quantity)
        end
      end
    end
  end
end
