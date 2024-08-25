require 'liquid'
require 'shopify_liquid_tags/render_tag'
require 'shopify_liquid_tags/capture_tag'

module ShopifyLiquidTags
  def self.register_tags
    Liquid::Template.register_tag('render', RenderTag)
    Liquid::Template.register_tag('capture', CaptureTag)
  end
end
