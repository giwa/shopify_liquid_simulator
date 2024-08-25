require 'spec_helper'

RSpec.describe ShopifyLiquidSimulator::Render do
  before(:all) do
    Liquid::Template.register_tag('render', ShopifyLiquidSimulator::Render)
    
    ShopifyLiquidSimulator::Render.snippet_provider = ->(name) {
      {
        'simple' => 'Hello, {{ name }}!',
        'for_loop' => 'Item: {{ item }}',
        'with_object' => 'Name: {{ object.name }}',
        'isolated' => '{{ outside_var }}',
        'forloop_vars' => '{{ forloop.index }},{{ forloop.index0 }},{{ forloop.first }},{{ forloop.last }},{{ forloop.length }},{{ forloop.rindex }},{{ forloop.rindex0 }}|'
      }[name]
    }
  end

  def render(template, assigns = {})
    Liquid::Template.parse(template).render(assigns)
  end

  it 'renders a simple snippet' do
    template = "{% render 'simple', name: 'World' %}"
    expect(render(template)).to eq 'Hello, World!'
  end

  it 'renders a snippet with a for loop' do
    template = "{% render 'for_loop' for items as item %}"
    assigns = { 'items' => %w[A B C] }
    expect(render(template, assigns)).to eq 'Item: AItem: BItem: C'
  end

  it 'renders a snippet with an object' do
    template = "{% render 'with_object' with user as object %}"
    assigns = { 'user' => { 'name' => 'John' } }
    expect(render(template, assigns)).to eq 'Name: John'
  end

  it 'does not allow access to variables outside the snippet' do
    template = "{% assign outside_var = 'Outside' %}{% render 'isolated' %}"
    expect(render(template)).to eq ''
  end

  it 'provides all forloop variables in for loop rendering' do
    template = "{% render 'forloop_vars' for items as item %}"
    assigns = { 'items' => %w[A B C] }
    expect(render(template, assigns)).to eq '1,0,true,false,3,3,2|2,1,false,false,3,2,1|3,2,false,true,3,1,0|'
  end

  it 'allows using an alias for the rendered variable' do
    template = "{% render 'simple' with 'Alias' as name %}"
    expect(render(template)).to eq 'Hello, Alias!'
  end

  it 'does not pollute the outer scope' do
    template = "{% render 'simple' with 'Inner' as name %}{{ name }}"
    assigns = { 'name' => 'Outer' }
    expect(render(template, assigns)).to eq 'Hello, Inner!Outer'
  end
end