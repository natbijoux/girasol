require 'spec_helper'

describe 'product rules' do
  products.each do |product|
    groups = rules.keys

    context "The #{product['title']} product" do
      groups.each do |group|
        valid_tags = rules[group].map { |r| r['tag'] }

        context "the #{group} group" do
          it 'should exist' do
            expect(product[group]).to_not be_nil
          end

          it 'should only contain valid tags' do
            extra = product[group] - valid_tags
            expect(extra).to be_empty
          end
        end
      end
    end
  end
end
