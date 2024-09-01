require 'json'
require 'digest'
require 'cgi'
require 'erb'
require 'openssl'
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
      result = input.to_s.downcase
      result = result.gsub(/[^a-z0-9-]/, '-')
      result = result.gsub(/-+/, '-')
      result.gsub(/^-|-$/, '')
    end

    def hmac_sha1(input, secret)
      # TODO: check to_s is necessary or not
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret.to_s, input.to_s)
    end

    def hmac_sha256(input, secret)
      # TODO: check to_s is necessary or not
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), secret.to_s, input.to_s)
    end

    def sha1(input)
      # TODO: check to_s is necessary or not
      Digest::SHA1.hexdigest(input.to_s)
    end

    def sha256(input)
      # TODO: check to_s is necessary or not
      Digest::SHA256.hexdigest(input.to_s)
    end

    def url_escape(input)
      ERB::Util.url_encode(input.to_s)
    end

    def url_param_escape(input)
      CGI.escape(input.to_s)
    end
  end
end
