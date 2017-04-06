module Spree
  module Stock
    Packer.class_eval do

      def default_package
        package = Package.new(stock_location)

        inventory_units.each do |inventory_unit|
          variant = inventory_unit.variant
          unit = inventory_unit.dup # Can be used by others, do not use directly
          if variant.should_track_inventory?
            next unless stock_location.stocks? variant
            on_hand, backordered = stock_location.fill_status(variant, unit.quantity)
            package.add(unit, :backordered) if backordered.positive?
            package.add(unit, :on_hand) if on_hand.positive?
          else
            package.add unit
          end
        end
        package
      end
    end
  end
end
