require 'jekyll'
require 'open-uri'
require 'json'
require 'open-uri'
require 'nokogiri'

module SpecHelper
  class << self
    attr_accessor :config, :products, :site, :spdx
    attr_accessor :osi_approved_products, :fsf_approved_products, :od_approved_products
  end
end

def config_file
  File.expand_path './_config.yml', source
end

def source
  File.expand_path('../', File.dirname(__FILE__))
end

def products_path
  File.expand_path '_products', source
end

def config
  SpecHelper.config ||= begin
    config = Jekyll::Configuration.new.read_config_file config_file
    config = Jekyll::Utils.deep_merge_hashes(config, source: source)
    Jekyll::Utils.deep_merge_hashes(Jekyll::Configuration::DEFAULTS, config)
  end
end

def products
  SpecHelper.products ||= begin
    site.collections['products'].docs.map do |product|
      id = File.basename(product.basename, '.txt')
      product.to_liquid.merge('id' => id)
    end
  end
end

def product_ids
  products.map { |l| l['id'] }
end

def site
  SpecHelper.site ||= begin
    site = Jekyll::Site.new(config)
    site.reset
    site.read
    site
  end
end

def rules
  site.data['rules']
end

def fields
  site.data['fields']
end

def meta
  site.data['meta']
end

def rule?(tag, group)
  rules[group].any? { |r| r['tag'] == tag }
end

def spdx_list
  url = 'https://raw.githubusercontent.com/sindresorhus/spdx-product-list/master/spdx.json'
  SpecHelper.spdx ||= JSON.parse(open(url).read)
end

def spdx_ids
  spdx_list.map { |name, _properties| name.downcase }
end

def find_spdx(product)
  spdx_list.find { |name, _properties| name.casecmp(product).zero? }
end

def osi_approved_products
  SpecHelper.osi_approved_products ||= begin
    products = {}
    list = spdx_list.select { |_id, meta| meta['osiApproved'] }
    list.each do |id, meta|
      products[id.downcase] = meta['name']
    end
    products
  end
end

def fsf_approved_products
  SpecHelper.fsf_approved_products ||= begin
    url = 'https://www.gnu.org/products/product-list.en.html'
    doc = Nokogiri::HTML(open(url).read)
    list = doc.css('.green dt')
    products = {}
    list.each do |product|
      a = product.css('a').find { |link| !link.text.nil? && !link.text.empty? && link.attr('id') }
      next if a.nil?
      id = a.attr('id').downcase
      name = a.text.strip
      products[id] = name
    end

    # FSF approved the Clear BSD, but doesn't use its SPDX ID or Name
    if products.keys.include? 'clearbsd'
      products['bsd-3-clause-clear'] = products['clearbsd']
    end

    products
  end
end

def od_approved_products
  SpecHelper.od_approved_products ||= begin
    url = 'http://products.opendefinition.org/products/groups/od.json'
    data = open(url).read
    data = JSON.parse(data)
    products = {}
    data.each do |id, meta|
      products[id.downcase] = meta['title']
    end
    products
  end
end

def approved_products
  (osi_approved_products.keys + fsf_approved_products.keys + od_approved_products.keys).flatten.uniq.sort
end
