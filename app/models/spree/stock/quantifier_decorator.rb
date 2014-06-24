Spree::Stock::Quantifier.class_eval do
  def total_on_hand
    if @variant.product.assembly?
      @variant.product.assemblies_parts.map(&:available_count).min
    elsif @variant.should_track_inventory?
      stock_items.sum(:count_on_hand)
    else
      Float::INFINITY
    end
  end
end
