require 'json'



module ShopifyLiquidSimulator
  module Filters
    # ref: https://github.com/Shopify/liquid/blob/main/performance/shopify/json_filter.rb
    def json(input)
      JSON.dump(input)
    end
  end
end