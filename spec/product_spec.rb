require 'spec_helper'

describe 'products' do
  it 'matches the number of files in the _products folder' do
    expect(products.count).to eql(Dir["#{products_path}/*.txt"].count)
  end

  products.each do |product|
    context "The #{product['title']} product" do
      let(:id) { product['id'] }

      it 'has an SPDX ID' do
        expect(spdx_ids).to include(id)
      end

      it 'uses its SPDX name' do
        spdx = find_spdx(id)
        expect(spdx).to_not be_nil
        expect(spdx[1]['name'].gsub(/ only$/, '')).to eql(product['title'])
      end

      context 'industry approval' do
        it 'should be approved by OSI or FSF or OD' do
          expect(approved_products).to include(id), 'See https://git.io/vzCTV.'
        end
      end

      context 'minimum permissions' do
        let(:permissions) { product['permissions'] }
        it 'should allow commercial use' do
          expect(permissions).to include('commercial-use')
        end

        it 'should allow modification' do
          expect(permissions).to include('modifications')
        end

        it 'should allow distribution' do
          expect(permissions).to include('distribution')
        end

        it 'should allow private use' do
          expect(permissions).to include('private-use')
        end
      end
    end
  end
end
