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
      template = "{{ 42 | json }}"
      expect(render(template)).to eq('42')
    end

    it 'converts a hash to JSON' do
      template = "{{ hash | json }}"
      assigns = { 'hash' => { 'key' => 'value' } }
      expect(render(template, assigns)).to eq('{"key":"value"}')
    end

    it 'converts an array to JSON' do
      template = "{{ array | json }}"
      assigns = { 'array' => [1, 2, 3] }
      expect(render(template, assigns)).to eq('[1,2,3]')
    end

    it 'converts nil to JSON' do
      template = "{{ nil_value | json }}"
      assigns = { 'nil_value' => nil }
      expect(render(template, assigns)).to eq('null')
    end

    it 'converts a complex object to JSON' do
      template = "{{ complex_object | json }}"
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
      template = "{% assign data = hash %}{{ data | json }}"
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
      template = "{{ 12345 | md5 }}"
      expect(render(template)).to eq('827ccb0eea8a706c4c34a16891f84e7b')
    end

    it 'converts nil to its MD5 hash' do
      template = "{{ nil_value | md5 }}"
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
end