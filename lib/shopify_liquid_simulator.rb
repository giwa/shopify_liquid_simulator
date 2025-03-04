require 'liquid'
require 'shopify_liquid_simulator/render'
require 'shopify_liquid_simulator/filters'

module ShopifyLiquidSimulator
  def self.register_tags
    Liquid::Environment.default.register_tag('render', Render)
    Liquid::Template.register_filter(Filters)
  end
end
