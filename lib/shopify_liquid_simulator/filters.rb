require 'json'
require 'digest'




module ShopifyLiquidSimulator
  module Filters
    # ref: https://github.com/Shopify/liquid/blob/main/performance/shopify/json_filter.rb
    def json(input)
      JSON.dump(input)
    end

    def md5(input)
      Digest::MD5.hexdigest(input.to_s)
    end
  end
end