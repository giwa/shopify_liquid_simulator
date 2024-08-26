require 'liquid'
require 'shopify_liquid_simulator/render'
require 'shopify_liquid_simulator/filters'

module ShopifyLiquidSimulator
  def self.register_tags
    Liquid::Template.register_tag('render', Render)
    Liquid::Template.register_filter(Filters)
  end
end
