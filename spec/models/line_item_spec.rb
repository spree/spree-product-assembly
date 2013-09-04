require 'spec_helper'

module Spree
  describe LineItem do
    let(:line_item) { Factory(:line_item) }
    let(:order) { line_item.order }
    let(:product) { line_item.product }
    let(:parts) { (1..3).map { Factory(:variant) } }

    context "updates item in completed order" do

      before do
        order.completed_at = Time.now
        order.save!
      end

      context "item is a regular product" do
        it "creates inventory units for the product" do
          line_item.update_attributes(quantity: line_item.quantity + 1)
          InventoryUnit.last.variant.should == line_item.variant
        end
      end

      context "item is a bundle" do
        before { product.parts << parts }

        it "creates inventory units for bundle parts" do
          line_item.update_attributes(quantity: line_item.quantity + 1)
          InventoryUnit.last(3).map(&:variant).should == parts
        end
      end

      context :validate_quantity_and_stock do
        before { product.parts << parts }

        it "should check line item has quantity" do
          line_item.stub(:quantity).and_return(-1)

          line_item.valid?

          line_item.errors.messages[:quantity].include?(I18n.t("validation.must_be_non_negative")).should be_true
        end

        it "should check inventory levels for line item" do
          line_item.stub(:quantity).and_return(1)
          line_item.stub(:variant).and_return(OpenStruct.new(on_hand: 0))

          line_item.valid?

          line_item.errors.messages[:quantity].include?(I18n.t("validation.exceeds_available_stock")).should be_true
        end

        it "should check inventory levels for parts" do
          part = parts[0]
          part.update_attributes(on_hand: 0)

          line_item.valid?

          error_message = I18n.t("validation.is_too_large") + " (#{product.name})"
          line_item.errors.messages[:quantity].include?(error_message).should be_true
        end
      end
    end
  end
end
