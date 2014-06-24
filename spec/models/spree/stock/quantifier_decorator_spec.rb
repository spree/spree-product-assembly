require 'spec_helper'

describe Spree::Stock::Quantifier do
  describe '.total_on_hand' do
    subject { Spree::Stock::Quantifier.new(variant).total_on_hand }

    context 'when variant is an assembly' do
      let(:the_cinco_complete_kit) { create :base_product }
      let(:cinco_fone) { create :base_variant }
      let(:cooling_gel) { create :base_variant }

      let(:variant) { the_cinco_complete_kit.master }

      before do
        cinco_fone.stock_items.first.adjust_count_on_hand 10
        cooling_gel.stock_items.first.adjust_count_on_hand 4

        the_cinco_complete_kit.add_part cinco_fone, 1
        the_cinco_complete_kit.add_part cooling_gel, 2
      end

      it 'returns the number of assembly that can be created' do
        expect(subject).to eq 2
      end
    end

    context 'when variant is not an assembly' do
      let!(:variant) { create :base_variant }

      context 'when the variant tracks inventory' do
        before do
          expect( variant ).to receive(:should_track_inventory?) { true }
          variant.stock_items.first.adjust_count_on_hand 1
        end

        it "returns the sum of it's stock items count on hand" do
          expect(subject).to eq 1
        end
      end

      context 'when the variant does not track inventory' do
        before do
          expect( variant ).to receive(:should_track_inventory?) { false }
        end

        it 'is infinite' do
          expect(subject).to eq Float::INFINITY
        end
      end
    end
  end
end
