module Spree
  Order.class_eval do
    def validate_parts_supply
      totals = {}

      quantity_by_variant = self.line_items.map(&:quantity_by_variant).flatten
      quantity_by_variant.each do |var_quanity|
        totals.merge!(var_quanity) do |key, new_val, prev_val|
          {
            count: new_val[:count] + prev_val[:count],
            variant: new_val[:variant],
          }
        end
      end

      totals.values.each do |total|
        quanitifier = Stock::Quantifier.new(total[:variant])
        unless quanitifier.can_supply? total[:count]
          self.errors[:"line_items.quantity"] << Spree.t(:out_of_stock, scope: :order_populator, item: total[:variant].name)
        end
      end
    end
  end
end
