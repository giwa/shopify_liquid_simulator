Gem::Specification.new do |s|
  s.name        = 'shopify_liquid_tags'
  s.version     = '0.1.0'
  s.summary     = 'Shopify Liquid custom tags'
  s.description = 'Simulate Shopify Liquid custom tags for testing purposes'
  s.authors     = ['Ken Takagiwa']
  s.email       = 'ugw.gi.world@gmail.com'
  s.files       = Dir['lib/**/*']
  s.homepage    = 'https://rubygems.org/gems/shopify_liquid_tags'
  s.license     = 'MIT'
  s.add_dependency 'liquid', '~> 5.0'
  s.add_development_dependency 'rspec', '~> 3.0'
end
