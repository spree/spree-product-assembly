module Spree
  module Stock
    Quantifier.class_eval do
      durably_decorate :total_on_hand, mode: 'strict', sha: 'ac5dc69a5cb0a26152c8578849f9481d0e3085ff' do
        if @variant.is_master?
          original_total_on_hand + @variant.product.parts_min_total_on_hand
        else
          original_total_on_hand
        end
      end
    end
  end
end
