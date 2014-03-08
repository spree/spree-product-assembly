Spree::Product.class_eval do
  scope :individual_saled, -> { where(["spree_products.individual_sale = ?", true]) }

  scope :search_can_be_part, ->(query){ not_deleted.available.joins(:master)
    .where(arel_table["name"].matches("%#{query}%").or(Spree::Variant.arel_table["sku"].matches("%#{query}%")))
    .where(can_be_part: true)
    .limit(30)
  }

  scope :active, lambda { |*args|
    not_deleted.individual_saled.available(nil, args.first)
  }

  validate :assembly_cannot_be_part, :if => :assembly?

  delegate :parts, :assemblies_parts, :add_part, :remove_part, :set_part_count, to: :master

  def assembly?
    parts.present?
  end

  def assembly_cannot_be_part
    errors.add(:can_be_part, Spree.t(:assembly_cannot_be_part)) if can_be_part
  end

  def assembly_part(variant)
    Spree::AssembliesPart.get(self.id, variant.id)
  end

  durably_decorate :total_on_hand , mode: 'strict', sha: 'bdc96bf9a2738a7e18fa3e1f431ccb9cda8b83a7' do
    total = original_total_on_hand
    total += parts_min_total_on_hand
    total
  end

  def parts_min_total_on_hand
    min = Float::INFINITY

    self.parts.map do |part|
      count = part.total_on_hand / assembly_part(part).count
      min = count if count < min
    end

    min != Float::INFINITY ? min : 0
  end
end
