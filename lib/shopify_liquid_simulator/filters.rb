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

    # ref https://shopify.dev/docs/api/liquid/basics#modifying-handles
    def handleize(input)
      result = input.to_s.downcase  # 小文字に変換
      
      # 空白と特殊文字をハイフンに置換
      result = result.gsub(/[^a-z0-9\-]/, '-')
      
      # 連続するハイフンを1つに
      result = result.gsub(/-+/, '-')
      
      # 先頭と末尾のハイフンを削除
      result = result.gsub(/^-|-$/, '')
      
      result
    end
  end
end
