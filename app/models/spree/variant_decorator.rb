Spree::Variant.class_eval do

  has_and_belongs_to_many  :assemblies, :class_name => "Spree::Product",
        :join_table => "spree_assemblies_parts",
        :foreign_key => "part_id", :association_foreign_key => "assembly_id"

  after_save :update_count_on_hand_if_assemblies



    def update_count_on_hand_if_assemblies
        if self.assemblies.present?
          self.assemblies.each do |product|
            product.update_assemblies_count_on_hand
          end
        end
    end

    def has_stock?
      self.on_hand > 0
    end

end
