require 'spec_helper'

describe 'product meta' do
  products.each do |product|
    # Manually load the raw product so we don't get the defaults
    raw_fields = SafeYAML.load_file("_products/#{product['id']}.txt")

    context "The #{product['title']} product" do
      it 'should only contain supported meta fields' do
        extra_fields = raw_fields.keys - meta.map { |m| m['name'] }
        expect(extra_fields).to be_empty
      end

      it 'should contain all required meta fields' do
        required = meta.select { |m| m['required'] }.map { |m| m['name'] }
        missing = required - raw_fields.keys
        expect(missing).to be_empty
      end
    end
  end
end
