Deface::Override.new(:virtual_path => "spree/shared/_order_details",
                     :name => "add_assembly_product_description",
                     :insert_bottom => "[data-hook='order_item_description']",
                     :partial => "spree/shared/assembly_product_description")
