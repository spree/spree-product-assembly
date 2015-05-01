class CreateSpreeAssemblyVariants < ActiveRecord::Migration
  def change
    create_table :spree_assembly_variants do |t|
      t.references :line_item
      t.references :variant

      t.timestamps
    end
  end
end
