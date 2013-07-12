Gem::Specification.new do |s|
  s.platform     = Gem::Platform::RUBY
  s.name         = 'spree_product_assembly'
  s.version      = '2.0.0.beta'
  s.summary      = 'Adds oportunity to make bundle of products to your Spree store'
  s.description  = s.summary
  s.required_ruby_version = '>= 1.9.3'

  s.author       = 'Roman Smirnov'
  s.email        = 'roman@railsdog.com'
  s.homepage     = 'https://github.com/spree/spree-product-assembly'
  s.license      = %q{BSD-3}

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- spec/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_runtime_dependency 'spree', '~> 2.0'

  s.add_development_dependency 'rspec-rails', '~> 2.13.0'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'factory_girl_rails', '~> 4.2.1'
end
