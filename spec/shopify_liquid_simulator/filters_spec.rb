require 'spec_helper'

RSpec.describe ShopifyLiquidSimulator::Filters do
  before(:all) do
    Liquid::Template.register_filter(ShopifyLiquidSimulator::Filters)
  end

  def render(template, assigns = {})
    Liquid::Template.parse(template).render(assigns)
  end

  describe '#json filter' do
    it 'converts a string to JSON' do
      template = "{{ 'hello' | json }}"
      expect(render(template)).to eq('"hello"')
    end

    it 'converts a number to JSON' do
      template = '{{ 42 | json }}'
      expect(render(template)).to eq('42')
    end

    it 'converts a hash to JSON' do
      template = '{{ hash | json }}'
      assigns = { 'hash' => { 'key' => 'value' } }
      expect(render(template, assigns)).to eq('{"key":"value"}')
    end

    it 'converts an array to JSON' do
      template = '{{ array | json }}'
      assigns = { 'array' => [1, 2, 3] }
      expect(render(template, assigns)).to eq('[1,2,3]')
    end

    it 'converts nil to JSON' do
      template = '{{ nil_value | json }}'
      assigns = { 'nil_value' => nil }
      expect(render(template, assigns)).to eq('null')
    end

    it 'converts a complex object to JSON' do
      template = '{{ complex_object | json }}'
      assigns = {
        'complex_object' => {
          'string' => 'hello',
          'number' => 42,
          'array' => [1, 2, 3],
          'nested' => { 'key' => 'value' }
        }
      }
      expected_json = '{"string":"hello","number":42,"array":[1,2,3],"nested":{"key":"value"}}'
      expect(render(template, assigns)).to eq(expected_json)
    end

    it 'works with variables in a Liquid template' do
      template = '{% assign data = hash %}{{ data | json }}'
      assigns = { 'hash' => { 'key' => 'value' } }
      expect(render(template, assigns)).to eq('{"key":"value"}')
    end
  end

  describe '#md5 filter' do
    it 'converts a string to its MD5 hash' do
      template = "{{ 'hello' | md5 }}"
      expect(render(template)).to eq('5d41402abc4b2a76b9719d911017c592')
    end

    it 'converts an empty string to its MD5 hash' do
      template = "{{ '' | md5 }}"
      expect(render(template)).to eq('d41d8cd98f00b204e9800998ecf8427e')
    end

    it 'converts a number to its MD5 hash' do
      template = '{{ 12345 | md5 }}'
      expect(render(template)).to eq('827ccb0eea8a706c4c34a16891f84e7b')
    end

    it 'converts nil to its MD5 hash' do
      template = '{{ nil_value | md5 }}'
      assigns = { 'nil_value' => nil }
      expect(render(template, assigns)).to eq('d41d8cd98f00b204e9800998ecf8427e')
    end

    it 'works with variables in a Liquid template' do
      template = "{% assign data = 'test data' %}{{ data | md5 }}"
      expect(render(template)).to eq('eb733a00c0c9d336e65691a37ab54293')
    end

    it 'produces consistent results for the same input' do
      template = "{{ 'consistent' | md5 }}"
      result1 = render(template)
      result2 = render(template)
      expect(result1).to eq(result2)
    end
  end

  describe '#camelize filter' do
    context 'with basic transformations' do
      test_cases = [
        ['hello_world', 'HelloWorld'],
        #  ['hello-world', 'HelloWorld'],
        #  ['hello world', 'HelloWorld'],
        #  ['hello_world-and-universe', 'HelloWorldAndUniverse'],
        ['hello_world_123', 'HelloWorld123'],
        #  ['HELLO_WORLD', 'HelloWorld'],
        ['Hello_World', 'HelloWorld'],
        ['hello__world', 'HelloWorld'],
        ['', ''],
        # Test cases with various languages
        ['こんにちは_世界', 'こんにちは世界'],       # Japanese
        ['ハロー_ワールド', 'ハローワールド'],       # Japanese (Katakana)
        ['你好_世界', '你好世界'], # Chinese
        ['안녕하세요_세계', '안녕하세요세계'], # Korean
        #  ['Здравствуй_мир', 'здравствуйМир'],        # Russian
        ['مرحبا_بالعالم', 'مرحبابالعالم'], # Arabic
        ['שלום_עולם', 'שלוםעולם'] # Hebrew
      ]

      test_cases.each do |input, expected|
        it "converts '#{input}' to '#{expected}'" do
          template = "{{ '#{input}' | camelize }}"
          expect(render(template)).to eq(expected)
        end
      end

      it 'handles nil values' do
        template = '{{ nil_value | camelize }}'
        assigns = { 'nil_value' => nil }
        expect(render(template, assigns)).to eq('')
      end

      it 'works with variables in a Liquid template' do
        template = "{% assign data = 'test_variable' %}{{ data | camelize }}"
        expect(render(template)).to eq('TestVariable')
      end
    end

    context 'with special characters' do
      test_cases = [
        # ['hello_(world)', 'HelloWorld'],
        #  ['hello_[world]', 'HelloWorld'],
        # ['hello_{world}', 'HelloWorld'],
        #  ['hello@world', 'HelloWorld'],
        #  ['hello$world', 'HelloWorld'],
        #  ['hello%world', 'HelloWorld'],
        #  ['hello^world', 'HelloWorld'],
        #  ['hello&world', 'HelloWorld'],
        #  ['hello*world', 'HelloWorld'],
        #  ['hello+world', 'HelloWorld'],
        #  ['hello=world', 'HelloWorld'],
        #  ['hello!world', 'HelloWorld'],
        #  ['hello?world', 'HelloWorld'],
        #  ['hello@world!_how$are^you?', 'HelloWorldHowAreYou'],
        #  ['hello\\world', 'HelloWorld'],
        #  ['hello/world/example', 'HelloWorldExample'],
        #  ['hello:world', 'HelloWorld'],
        #  ['hello;world', 'HelloWorld'],
        # Test cases with special characters in various languages
        ['こんにちは@世界', 'こんにちは世界'], # Japanese
        #  ['ハロー_ワールド！', 'ハローワールド'],     # Japanese (Katakana)
        ['你好_世界123', '你好世界123'], # Chinese
        ['안녕하세요_세계!', '안녕하세요세계'], # Korean
        #  ['Здравствуй@мир', 'здравствуймир'],        # Russian (note: all lowercase)
        ['مرحبا_بالعالم!', 'مرحبابالعالم'], # Arabic
        ['שלום_עולם?', 'שלוםעולם'] # Hebrew
      ]

      test_cases.each do |input, expected|
        it "handles '#{input}' correctly" do
          template = "{{ '#{input}' | camelize }}"
          expect(render(template)).to eq(expected)
        end
      end
    end

    context 'with edge cases' do
      it 'handles strings with only special characters' do
        template = "{{ '@#$%^&*' | camelize }}"
        expect(render(template)).to eq('')
      end

      xit 'handles mixed alphanumeric, multi-language, and special characters' do
        template = "{{ 'a1@こんにちは#c3$世界_안녕하세요%Здравствуй' | camelize }}"
        expect(render(template)).to eq('a1こんにちはc3世界안녕하세요здравствуй')
      end

      it 'preserves numbers and multi-language characters in the correct position' do
        template = "{{ 'hello_123_世界_456_안녕하세요_789' | camelize }}"
        expect(render(template)).to eq('Hello123世界456안녕하세요789')
      end

      it 'handles strings with various Unicode characters' do
        template = "{{ 'ß_æ_ø_å_ñ_ü_ç' | camelize }}"
        expect(render(template)).to eq('ßæøåñüç')
      end
    end
  end

  describe '#handleize filter' do
    it 'converts a simple string to handle format' do
      template = "{{ 'Hello World' | handleize }}"
      expect(render(template)).to eq('hello-world')
    end

    it 'converts a string with multiple spaces to handle format' do
      template = "{{ 'Foo    Bar' | handleize }}"
      expect(render(template)).to eq('foo-bar')
    end

    xit 'converts a string with special characters to handle format' do
      template = "{{ 'Special@#{$Characters}!' | handleize }}"
      expect(render(template)).to eq('special-characters')
    end

    it 'removes leading and trailing special characters' do
      template = "{{ '--Trim This--' | handleize }}"
      expect(render(template)).to eq('trim-this')
    end

    it 'handles empty string' do
      template = "{{ '' | handleize }}"
      expect(render(template)).to eq('')
    end

    it 'converts numbers to handle format' do
      template = '{{ 12345 | handleize }}'
      expect(render(template)).to eq('12345')
    end

    it 'handles nil value' do
      template = '{{ nil_value | handleize }}'
      assigns = { 'nil_value' => nil }
      expect(render(template, assigns)).to eq('')
    end

    it 'works with variables in a Liquid template' do
      template = "{% assign data = 'Test Data 123' %}{{ data | handleize }}"
      expect(render(template)).to eq('test-data-123')
    end

    it 'produces consistent results for the same input' do
      template = "{{ 'Consistent Result' | handleize }}"
      result1 = render(template)
      result2 = render(template)
      expect(result1).to eq(result2)
    end

    it 'handles mixed case input' do
      template = "{{ 'MiXeD cAsE' | handleize }}"
      expect(render(template)).to eq('mixed-case')
    end

    it 'handles input with only special characters' do
      template = "{{ '@#$%^&*()' | handleize }}"
      expect(render(template)).to eq('')
    end
  end

  describe '#hmac_sha1 filter' do
    it 'converts a string to its HMAC-SHA1 hash' do
      template = "{{ 'Polyjuice' | hmac_sha1: 'Polina' }}"
      expect(render(template)).to eq('63304203b005ea4bc80546f1c6fdfe252d2062b2')
    end

    it 'handles empty string as input' do
      template = "{{ '' | hmac_sha1: 'secret' }}"
      expect(render(template)).to eq('25af6174a0fcecc4d346680a72b7ce644b9a88e8')
    end

    it 'handles empty string as secret' do
      template = "{{ 'input' | hmac_sha1: '' }}"
      expect(render(template)).to eq('aaadf4e0a7a6eb442e38613aa9db487b853b41f8')
    end

    it 'handles numbers as input' do
      template = "{{ 12345 | hmac_sha1: 'secret' }}"
      expect(render(template)).to eq('3beb4dcd4d5276a3107ef503d83c8ea978e4fe1b')
    end

    it 'handles numbers as secret' do
      template = "{{ 'input' | hmac_sha1: 12345 }}"
      expect(render(template)).to eq('0745de3ce921bd794ccae194c57d808a071d4ba7')
    end

    it 'handles nil as input' do
      template = "{{ nil | hmac_sha1: 'secret' }}"
      expect(render(template)).to eq('25af6174a0fcecc4d346680a72b7ce644b9a88e8')
    end

    it 'handles nil as secret' do
      template = "{{ 'input' | hmac_sha1: nil }}"
      expect(render(template)).to eq('aaadf4e0a7a6eb442e38613aa9db487b853b41f8')
    end

    it 'works with variables in a Liquid template' do
      template = "{% assign data = 'test data' %}{% assign secret = 'my secret' %}{{ data | hmac_sha1: secret }}"
      expect(render(template)).to eq('67e1024dc7bfdc46dcddb7372ea9c6210f070c2b')
    end

    it 'produces consistent results for the same input and secret' do
      template = "{{ 'consistent' | hmac_sha1: 'secret' }}"
      result1 = render(template)
      result2 = render(template)
      expect(result1).to eq(result2)
    end
  end
  describe '#hmac_sha256 filter' do
    it 'converts a string to its HMAC-SHA256 hash' do
      template = "{{ 'Polyjuice' | hmac_sha256: 'Polina' }}"
      expect(render(template)).to eq('8e0d5d65cff1242a4af66c8f4a32854fd5fb80edcc8aabe9b302b29c7c71dc20')
    end

    it 'handles empty string as input' do
      template = "{{ '' | hmac_sha256: 'secret' }}"
      expect(render(template)).to eq('f9e66e179b6747ae54108f82f8ade8b3c25d76fd30afde6c395822c530196169')
    end

    it 'handles empty string as secret' do
      template = "{{ 'input' | hmac_sha256: '' }}"
      expect(render(template)).to eq('23d1b3285a1bef3be4161a8b59437999de3d2a02b966fdad5c5dd810d3c97087')
    end

    it 'handles numbers as input' do
      template = "{{ 12345 | hmac_sha256: 'secret' }}"
      expect(render(template)).to eq('4beb2ca1a6c471e4c2e29ee140ab5c180a64e0f0f18de539f04c2d5e4c3d72fa')
    end

    it 'handles numbers as secret' do
      template = "{{ 'input' | hmac_sha256: 12345 }}"
      expect(render(template)).to eq('c64d768bba2b0b228d9318b12f4be3be5fd48abd32a72db00e88cf3fe690d5d4')
    end

    it 'handles nil as input' do
      template = "{{ nil | hmac_sha256: 'secret' }}"
      expect(render(template)).to eq('9a4a41cc8f1d7bc2b2f48e6dea9e95f1d3ec5cba4d53c83d1a7897f1f0e6db2a')
    end

    it 'handles nil as secret' do
      template = "{{ 'input' | hmac_sha256: nil }}"
      expect(render(template)).to eq('4ca4be77b5a8c0a78c86174b8f3d2d4d0a6f18f83b8a4c0e746c8c987f254c3b')
    end

    it 'works with variables in a Liquid template' do
      template = "{% assign data = 'test data' %}{% assign secret = 'my secret' %}{{ data | hmac_sha256: secret }}"
      expect(render(template)).to eq('9181e91f1a7a79251f217b8cbcaec0511e0c1c7ab4c3f72d79e0c7b26e9f9102')
    end

    it 'produces consistent results for the same input and secret' do
      template = "{{ 'consistent' | hmac_sha256: 'secret' }}"
      result1 = render(template)
      result2 = render(template)
      expect(result1).to eq(result2)
    end

    it 'produces different results for different secrets' do
      template1 = "{{ 'input' | hmac_sha256: 'secret1' }}"
      template2 = "{{ 'input' | hmac_sha256: 'secret2' }}"
      result1 = render(template1)
      result2 = render(template2)
      expect(result1).not_to eq(result2)
    end

    it 'produces different results for different inputs' do
      template1 = "{{ 'input1' | hmac_sha256: 'secret' }}"
      template2 = "{{ 'input2' | hmac_sha256: 'secret' }}"
      result1 = render(template1)
      result2 = render(template2)
      expect(result1).not_to eq(result2)
    end
  end

  describe '#sha1 filter' do
    it 'converts a string to its SHA1 hash' do
      template = "{{ 'hello' | sha1 }}"
      expect(render(template)).to eq('aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d')
    end

    it 'handles empty string' do
      template = "{{ '' | sha1 }}"
      expect(render(template)).to eq('da39a3ee5e6b4b0d3255bfef95601890afd80709')
    end

    it 'handles numbers' do
      template = '{{ 12345 | sha1 }}'
      expect(render(template)).to eq('8cb2237d0679ca88db6464eac60da96345513964')
    end

    it 'handles nil' do
      template = '{{ nil | sha1 }}'
      expect(render(template)).to eq('da39a3ee5e6b4b0d3255bfef95601890afd80709')
    end

    it 'works with variables in a Liquid template' do
      template = "{% assign data = 'test data' %}{{ data | sha1 }}"
      expect(render(template)).to eq('f48dd853820860816c75d54d0f584dc863327a7c')
    end

    it 'produces consistent results for the same input' do
      template = "{{ 'consistent' | sha1 }}"
      result1 = render(template)
      result2 = render(template)
      expect(result1).to eq(result2)
    end
  end

  describe '#sha256 filter' do
    it 'converts a string to its SHA256 hash' do
      template = "{{ 'hello' | sha256 }}"
      expect(render(template)).to eq('2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824')
    end

    it 'handles empty string' do
      template = "{{ '' | sha256 }}"
      expect(render(template)).to eq('e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855')
    end

    it 'handles numbers' do
      template = '{{ 12345 | sha256 }}'
      expect(render(template)).to eq('5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5')
    end

    it 'handles nil' do
      template = '{{ nil | sha256 }}'
      expect(render(template)).to eq('e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855')
    end

    it 'works with variables in a Liquid template' do
      template = "{% assign data = 'test data' %}{{ data | sha256 }}"
      expect(render(template)).to eq('916f0027a575074ce72a331777c3478d6513f786a591bd892da1a577bf2335f9')
    end

    it 'produces consistent results for the same input' do
      template = "{{ 'consistent' | sha256 }}"
      result1 = render(template)
      result2 = render(template)
      expect(result1).to eq(result2)
    end
  end

  describe '#url_escape filter' do
    it 'escapes URL-unsafe characters in a string' do
      template = "{{ '<p>Health & Love potions</p>' | url_escape }}"
      expect(render(template)).to eq('%3Cp%3EHealth%20%26%20Love%20potions%3C%2Fp%3E')
    end

    it 'handles empty string' do
      template = "{{ '' | url_escape }}"
      expect(render(template)).to eq('')
    end

    it 'handles string with no URL-unsafe characters' do
      template = "{{ 'SafeString123' | url_escape }}"
      expect(render(template)).to eq('SafeString123')
    end

    it 'escapes spaces' do
      template = "{{ 'Hello World' | url_escape }}"
      expect(render(template)).to eq('Hello%20World')
    end

    it 'escapes special characters' do
      template = "{{ '!@#$%^&*()' | url_escape }}"
      expect(render(template)).to eq('%21%40%23%24%25%5E%26%2A%28%29')
    end

    it 'escapes non-ASCII characters' do
      template = "{{ 'こんにちは' | url_escape }}"
      expect(render(template)).to eq('%E3%81%93%E3%82%93%E3%81%AB%E3%81%A1%E3%81%AF')
    end

    it 'handles numbers' do
      template = '{{ 12345 | url_escape }}'
      expect(render(template)).to eq('12345')
    end

    it 'handles nil' do
      template = '{{ nil | url_escape }}'
      expect(render(template)).to eq('')
    end

    it 'works with variables in a Liquid template' do
      template = "{% assign data = '<script>alert(\"XSS\")</script>' %}{{ data | url_escape }}"
      expect(render(template)).to eq('%3Cscript%3Ealert%28%22XSS%22%29%3C%2Fscript%3E')
    end

    it 'produces consistent results for the same input' do
      template = "{{ 'consistent & string' | url_escape }}"
      result1 = render(template)
      result2 = render(template)
      expect(result1).to eq(result2)
    end

    it 'escapes query parameters correctly' do
      template = "{{ 'key=value&another=123' | url_escape }}"
      expect(render(template)).to eq('key%3Dvalue%26another%3D123')
    end
  end

  describe '#url_param_escape filter' do
    it 'escapes URL parameter unsafe characters in a string' do
      template = "{{ '<p>Health & Love potions</p>' | url_param_escape }}"
      expect(render(template)).to eq('%3Cp%3EHealth+%26+Love+potions%3C%2Fp%3E')
    end

    it 'handles empty string' do
      template = "{{ '' | url_param_escape }}"
      expect(render(template)).to eq('')
    end

    it 'handles string with no URL-unsafe characters' do
      template = "{{ 'SafeString123' | url_param_escape }}"
      expect(render(template)).to eq('SafeString123')
    end

    it 'escapes spaces as plus signs' do
      template = "{{ 'Hello World' | url_param_escape }}"
      expect(render(template)).to eq('Hello+World')
    end

    it 'escapes special characters including &' do
      template = "{{ '!@#$%^&*()' | url_param_escape }}"
      expect(render(template)).to eq('%21%40%23%24%25%5E%26%2A%28%29')
    end

    it 'escapes non-ASCII characters' do
      template = "{{ 'こんにちは' | url_param_escape }}"
      expect(render(template)).to eq('%E3%81%93%E3%82%93%E3%81%AB%E3%81%A1%E3%81%AF')
    end

    it 'handles numbers' do
      template = '{{ 12345 | url_param_escape }}'
      expect(render(template)).to eq('12345')
    end

    it 'handles nil' do
      template = '{{ nil | url_param_escape }}'
      expect(render(template)).to eq('')
    end

    it 'works with variables in a Liquid template' do
      template = "{% assign data = '<script>alert(\"XSS\")</script>' %}{{ data | url_param_escape }}"
      expect(render(template)).to eq('%3Cscript%3Ealert%28%22XSS%22%29%3C%2Fscript%3E')
    end

    it 'produces consistent results for the same input' do
      template = "{{ 'consistent & string' | url_param_escape }}"
      result1 = render(template)
      result2 = render(template)
      expect(result1).to eq(result2)
    end

    it 'escapes query parameters correctly' do
      template = "{{ 'key=value&another=123' | url_param_escape }}"
      expect(render(template)).to eq('key%3Dvalue%26another%3D123')
    end

    it 'escapes & character' do
      template = "{{ 'param1=value1&param2=value2' | url_param_escape }}"
      expect(render(template)).to eq('param1%3Dvalue1%26param2%3Dvalue2')
    end

    it 'escapes + character' do
      template = "{{ 'a+b=c+d' | url_param_escape }}"
      expect(render(template)).to eq('a%2Bb%3Dc%2Bd')
    end
  end
end
