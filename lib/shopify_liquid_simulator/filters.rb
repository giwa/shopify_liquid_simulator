require 'json'
require 'digest'
require 'active_support/core_ext/string/inflections'

module ShopifyLiquidSimulator
  module Filters
    # ref: https://github.com/Shopify/liquid/blob/main/performance/shopify/json_filter.rb
    def json(input)
      JSON.dump(input)
    end

    def md5(input)
      Digest::MD5.hexdigest(input.to_s)
    end

    # TODO: support Multilingual
    def camelize(input)
      return '' if input.nil?

      result = input.camelize
      result.gsub(%r{[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>?/~`]}, '')
    end
  end
end
