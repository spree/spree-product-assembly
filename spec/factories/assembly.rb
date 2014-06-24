FactoryGirl.define do
  factory :assembly, class: 'Spree::Product', parent: :base_product do
    ignore do
      parts []
    end

    after :create do |assembly, evaluator|
      evaluator.parts.each do |part, quantity|
        assembly.add_part part, quantity
      end

      if assembly.parts.empty?
        assembly.add_part create(:base_variant), 1
      end

      assembly.save!
    end
  end
end
