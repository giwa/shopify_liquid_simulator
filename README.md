# Shopify Liquid Simulator

Shopify Liquid Simulator is a Ruby gem that aims to replicate the behavior of Shopify's custom Liquid implementation. This tool is designed for developers who want to test and develop Shopify themes locally without the need for a live Shopify store.

## Features

- Simulates Shopify-specific Liquid tags and filters
- Provides a testing environment for Shopify themes with shopify_liquid_test_helper gem
- Helps in debugging Liquid templates offline

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shopify_liquid_simulator'
```

And then execute:

```
$ bundle install
```

Or install it yourself as:

```
$ gem install shopify_liquid_simulator
```

## Usage

This gem is supposed to used with shopify_liquid_test_helper gem.

## Implementation Status

The following table shows the implementation status of Shopify Liquid tags and filters in comparison to the standard Liquid gem and our Shopify Liquid Simulator.
Object will not be implemented because ruby object might be sufficient for the testing purpose.
The first road map is implementing features for testing snippets.

| Name                   | Category | Shopify Liquid | Liquid OSS | Shopify Liquid Simulator |
| ---------------------- | -------- | -------------- | ---------- | ---------------------- |
| render                 | tag      | ✓              | ✓          | ✓                      |
| abs                    | filter   | ✓              | ✓          |                        |
| append                 | filter   | ✓              | ✓          |                        |
| at_least               | filter   | ✓              | ✓          |                        |
| at_most                | filter   | ✓              | ✓          |                        |
| base64_decode          | filter   | ✓              | ✓          |                        |
| base64_encode          | filter   | ✓              | ✓          |                        |
| base64_url_safe_decode | filter   | ✓              | ✓          |                        |
| base64_url_safe_encode | filter   | ✓              | ✓          |                        |
| camelize               | filter   | ✓              |            |                        |
| capitalize             | filter   | ✓              | ✓          |                        |
| ceil                   | filter   | ✓              | ✓          |                        |
| compact                | filter   | ✓              | ✓          |                        |
| concat                 | filter   | ✓              | ✓          |                        |
| date                   | filter   | ✓              | ✓          |                        |
| default                | filter   | ✓              | ✓          |                        |
| divided_by             | filter   | ✓              | ✓          |                        |
| downcase               | filter   | ✓              | ✓          |                        |
| escape                 | filter   | ✓              | ✓          |                        |
| escape_once            | filter   | ✓              | ✓          |                        |
| first                  | filter   | ✓              | ✓          |                        |
| floor                  | filter   | ✓              | ✓          |                        |
| handleize              | filter   | ✓              |            |                        |
| hmac_sha1              | filter   | ✓              |            |                        |
| hmac_sha256            | filter   | ✓              |            |                        |
| join                   | filter   | ✓              | ✓          |                        |
| json                   | filter   | ✓              |            | ✓                      |
| last                   | filter   | ✓              | ✓          |                        |
| lstrip                 | filter   | ✓              | ✓          |                        |
| map                    | filter   | ✓              | ✓          |                        |
| md5                    | filter   | ✓              |            | ✓                      |
| minus                  | filter   | ✓              | ✓          |                        |
| modulo                 | filter   | ✓              | ✓          |                        |
| newline_to_br          | filter   | ✓              | ✓          |                        |
| plus                   | filter   | ✓              | ✓          |                        |
| prepend                | filter   | ✓              | ✓          |                        |
| remove                 | filter   | ✓              | ✓          |                        |
| remove_first           | filter   | ✓              | ✓          |                        |
| remove_last            | filter   | ✓              | ✓          |                        |
| replace                | filter   | ✓              | ✓          |                        |
| replace_first          | filter   | ✓              | ✓          |                        |
| replace_last           | filter   | ✓              | ✓          |                        |
| reverse                | filter   | ✓              | ✓          |                        |
| round                  | filter   | ✓              | ✓          |                        |
| rstrip                 | filter   | ✓              | ✓          |                        |
| sha1                   | filter   | ✓              |            |                        |
| sha256                 | filter   | ✓              |            |                        |
| size                   | filter   | ✓              | ✓          |                        |
| slice                  | filter   | ✓              | ✓          |                        |
| sort                   | filter   | ✓              | ✓          |                        |
| sort_natural           | filter   | ✓              | ✓          |                        |
| split                  | filter   | ✓              | ✓          |                        |
| strip                  | filter   | ✓              | ✓          |                        |
| strip_html             | filter   | ✓              | ✓          |                        |
| strip_newlines         | filter   | ✓              | ✓          |                        |
| sum                    | filter   | ✓              | ✓          |                        |
| times                  | filter   | ✓              | ✓          |                        |
| truncate               | filter   | ✓              | ✓          |                        |
| truncatewords          | filter   | ✓              | ✓          |                        |
| uniq                   | filter   | ✓              | ✓          |                        |
| upcase                 | filter   | ✓              | ✓          |                        |
| url_decode             | filter   | ✓              | ✓          |                        |
| url_encode             | filter   | ✓              | ✓          |                        |
| url_escape             | filter   | ✓              |            |                        |
| url_param_escape       | filter   | ✓              |            |                        |
| where                  | filter   | ✓              | ✓          |                        |

Legend:

- ✓: Implemented
- Empty: Not implemented

## Contributing

We welcome contributions to the Shopify Liquid Simulator! If you'd like to contribute, please:

1. Fork the repository
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Testing

'''
bundle exec rspec
'''

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Disclaimer

This project is not officially affiliated with or endorsed by Shopify. It is an independent tool created by the community for testing and development purposes.
