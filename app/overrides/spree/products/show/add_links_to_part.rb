Deface::Override.new(:virtual_path  => 'spree/products/_cart_form',
                     :name          => 'assemebly_product_show',
                     :insert_before => "[data-hook='inside_product_cart_form']",
                     :partial      => 'spree/products/part_products',
                     :disabled => false
                    )