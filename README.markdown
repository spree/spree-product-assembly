# Spree Product Assembly

[![Build Status](https://travis-ci.org/westonplatter/spree-product-assembly.png)](https://travis-ci.org/westonplatter/spree-product-assembly)

Create a product which is composed of other products.

*This is still beta so beware it may not work as expected on Spree 2.0 for now.
Still please try it out and let us know if you find any issues*

## Installation

Add the following line to your Gemfile

    gem "spree_product_assembly", :git => "git://github.com/spree/spree-product-assembly.git"

Run bundle install as well as the extension intall command to copy and run migrations

    bundle install
    rails g spree_product_assembly:install

_Use 1-3-stable branch for Spree 1.3.x compatibility_

## Testing

You'll need to create a simple spree app to test the extension within. Create the spree dummy app via,  

    bundle exec rake test_app

And run the test via standard rake task,  

    bundle exec rake spec

## Use

This extension adds a `can_be_part` boolean attribute to the spree_products_table.
You'll need to check that flag on the backend product form so that it can be
be found by the parts search form.

Once a product is included as a _part_ of another it will be included on the order
shipment with zero costs.
