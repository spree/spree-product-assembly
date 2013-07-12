# Product Assembly

[![Build Status](https://secure.travis-ci.org/spree/spree-product-assembly.png?branch=master)](http://travis-ci.org/spree/spree-product-assembly)

Create a product which is composed of other products.

## Installation

Add the following line to your `Gemfile`:
``ruby
gem 'spree_product_assembly', github: 'spree/spree-product-assembly'
``

Run bundle install as well as the extension intall command to copy and run migrations and
append spree_product_assembly to your js manifest file

    bundle install
    rails g spree_product_assembly:install

_Use 1-3-stable branch for Spree 1.3.x compatibility_

_In case you're upgrading from 1-3-stable of this extension you might want to run a
rake task which assigns a line item to your previous inventory units from bundle
products. That is so you have a better view on the current backend UI and avoid
exceptions. No need to run this task if you're not upgrading from product assembly
1-3-stable_

    rake spree_product_assembly:upgrade

# Use

This extension adds a `can_be_part` boolean attribute to the spree_products_table.
You'll need to check that flag on the backend product form so that it can be
be found by the parts search form on the bundle product.

Once a product is included as a _part_ of another it will be included on the order
shipment and inventory units for each part will be created accordingly.

## Contributing

In the spirit of [free software][1], **everyone** is encouraged to help improve this project.

Here are some ways *you* can contribute:

* by using prerelease versions
* by reporting [bugs][2]
* by suggesting new features
* by writing [translations][5]
* by writing or editing documentation
* by writing specifications
* by writing code (*no patch is too small*: fix typos, add comments, clean up inconsistent whitespace)
* by refactoring code
* by resolving [issues][2]
* by reviewing patches

Starting point:

* Fork the repo
* Clone your repo
* Run `bundle install`
* Run `bundle exec rake test_app` to create the test application in `spec/test_app`
* Make your changes and follow this [Style Guide][4]
* Ensure specs pass by running `bundle exec rspec spec`
* Submit your pull request

Copyright (c) 2013 Roman Smirnov, released under the [New BSD License][3]

[1]: http://www.fsf.org/licensing/essays/free-sw.html
[2]: https://github.com/spree/spree-product-assembly/issues
[3]: https://github.com/spree/spree-product-assembly/tree/master/LICENSE.md
[4]: https://github.com/thoughtbot/guides
[5]: http://www.localeapp.com/projects/4909
