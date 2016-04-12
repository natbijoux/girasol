require 'spec_helper'

describe 'product fillable fields' do
  products.each do |product|
    context "The #{product['title']} product" do
      it 'should only contain supported fillable fields' do
        matches = product['content'].scan(/\[([a-z]+)\]/)
        extra_fields = matches.flatten - fields.map { |f| f['name'] }
        expect(extra_fields).to be_empty
      end
    end
  end
end
