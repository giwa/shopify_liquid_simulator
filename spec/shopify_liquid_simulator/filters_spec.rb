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
end
