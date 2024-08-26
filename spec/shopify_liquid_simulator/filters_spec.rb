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
end