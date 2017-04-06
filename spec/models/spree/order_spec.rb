module Spree
  describe Order, type: :model do

    let(:order) { create(:order_with_line_items) }
    let(:line_item) { order.line_items.first }
    let(:bundle) { line_item.product }
    let(:parts) { (1..3).map { create(:variant) } }

    before do
      bundle.master.parts << [parts]

      order.contents.update_cart({line_items_attributes: {
        id: line_item.id,
        quantity: 3,
        options: {}
      }})

      order.next
      order.reload.create_proposed_shipments
      order.finalize!
    end

    context "product assembly is added to shipment of completed order" do
      it "sets items number bigger than existing item number - adds inventory units to shipment package" do
        order.contents.update_cart({line_items_attributes: {
          id: line_item.id,
          quantity: 4,
          options: {}
        }})

        line_item_quantity = line_item.reload.quantity
        units_quantity = 0
        order.reload.shipments.each { |s| units_quantity += s.inventory_units.count }

        expect(line_item_quantity).to eq(4)
        expect(units_quantity).to eq(4 * 3)
      end
    end

    context "product assembly is removed from shipment of completed order" do
      it "sets items number lower than existing item number - removes inventory units from shipment package" do

        order.contents.update_cart({line_items_attributes: {
                id: line_item.id,
                quantity: 1,
                options: {}
            }})

        line_item_quantity = line_item.reload.quantity
        units_quantity = 0
        order.reload.shipments.each { |s| units_quantity += s.inventory_units.count }

        expect(line_item_quantity).to eq(1)
        expect(units_quantity).to eq(1 * 3)
      end
    end
  end
end
