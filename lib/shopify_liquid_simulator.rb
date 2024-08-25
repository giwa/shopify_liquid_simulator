require 'liquid'
require 'shopify_liquid_simulator/render'

module ShopifyLiquidSimulator
  def self.register_tags
    Liquid::Template.register_tag('render', Render)
  end
end
