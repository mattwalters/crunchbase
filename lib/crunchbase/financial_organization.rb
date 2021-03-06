require 'date'
module Crunchbase
  # Represents a Financial Organization listed in the Crunchbase.
  class FinancialOrganization < CB_Object
    
    ENT_NAME = "financial-organization"
    ENT_PLURAL = "financial-organizations"
    
    include Crunchbase::DateMethods
    
    attr_reader :name, :permalink, :crunchbase_url, :homepage_url, :blog_url,
      :blog_feed_url, :twitter_username, :phone_number, :description,
      :email_address, :number_of_employees, :created_at, :updated_at, 
      :overview, :image, :offices, :funds, :video_embeds, :external_links,
      :founded_year, :founded_month, :founded_day
    
    def initialize(json)
      @name = json['name']
      @permalink = json['permalink']
      @crunchbase_url = json['crunchbase_url']
      @homepage_url = json['homepage_url']
      @blog_url = json['blog_url']
      @blog_feed_url = json['blog_feed_url']
      @twitter_username = json['twitter_username']
      @phone_number = json['phone_number']
      @description = json['description']
      @email_address = json['email_address']
      @number_of_employees = json['number_of_employees']
      @founded_year = json['founded_year']
      @founded_month = json['founded_month']
      @founded_day = json['founded_day']
      @tag_list = json['tag_list']
      @alias_list = json['alias_list']
      @created_at = DateTime.parse(json["created_at"])
      @updated_at = DateTime.parse(json["updated_at"])
      @overview = json['overview']
      @image = Image.create(json['image'])
      @offices = json['offices']
      @relationships_list = json["relationships"]
      @investments_list = json['investments']
      @milestones_list = json['milestones']
      @providerships_list = json["providerships"]
      @funds = json['funds']
      @video_embeds = json['video_embeds']
      @external_links = json['external_links']
    end
    
    def relationships
      @relationships ||= Relationship.array_from_list(@relationships_list)
    end

    def providerships
      @providerships ||= Relationship.array_from_list(@providerships_list)
    end

    def investments
      @investments ||= Investment.array_from_list(@investments_list)
    end

    def milestones
      @milestones ||= Milestone.array_from_list(@milestones_list)
    end

    def founded?
      !!(@founded_year || @founded_month || @founded_day)
    end

    # Returns the date the financial org was founded, or nil if not provided.
    def founded
      @founded ||= date_from_components(@founded_year, @founded_month, @founded_day)    
    end
  end
end
