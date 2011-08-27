module Rubillow
  module Models
    # List of updated attributes for a property.
    class UpdatedPropertyDetails < Base
      include Zpidable
      include Addressable
      include Linkable
      include Images
      
      # @return [Hash] number of page views (:current_month, :total).
      attr_accessor :page_views
      # @return [String] price.
      attr_accessor :price
      # @return [String] neighborhood.
      attr_accessor :neighborhood
      # @return [String] elementary school's name.
      attr_accessor :elementary_school
      # @return [String] middle school's name.
      attr_accessor :middle_school
      # @return [String] school district's name.
      attr_accessor :school_district
      # @return [String] Realtor provided home description
      attr_accessor :home_description
      # @return [Hash] posting information 
      attr_accessor :posting
      # @return [Hash] list of edited facts
      attr_accessor :edited_facts
      
      protected
      
      # @private
      def parse
        super
        
        return if !success?
        
        extract_zpid(@parser)
        extract_links(@parser)
        extract_address(@parser)
        extract_images(@parser)
        
        @page_views = {
          :current_month => @parser.xpath('//pageViewCount/currentMonth').text,
          :total => @parser.xpath('//pageViewCount/total').text
        }
        @price = @parser.xpath('//price').text
        @neighborhood = @parser.xpath('//neighborhood').text
        @school_district = @parser.xpath('//schoolDistrict').text
        @elementary_school = @parser.xpath('//elementarySchool').text
        @middle_school = @parser.xpath('//middleSchool').text
        @home_description = @parser.xpath('//homeDescription').text
        
        @posting = {}
        @parser.xpath('//posting').children.each do |elm|
          @posting[elm.name.underscore.to_sym] = elm.text
        end
        
        @edited_facts = {}
        @parser.xpath('//editedFacts').children.each do |elm|
          @edited_facts[elm.name.underscore.to_sym] = elm.text
        end
      end
    end
  end
end