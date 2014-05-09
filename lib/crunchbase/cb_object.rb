module Crunchbase
  
  # Represents any object which can be pulled directly from the CB API.
  class CB_Object
    
    # Must be overridden in subclasses
    ENT_NAME = "undefined"
    ENT_PLURAL = "undefineds"

    attr_reader :type, :available_properties

    def initialize(json)
      @type = json["data"]["type"]
      @available_properties = json["data"]["properties"].keys
      json["data"]["properties"].each do |property_name, value|
	define_singleton_method(property_name) { value }
      end
      @available_relationships = json["data"]["relationships"].keys
    end
    
    # Returns an array of tags
    def tags
      @tag_list.respond_to?('split') ? @tag_list.split(/,\s*/) : []
    end
    
    # Returns an array of aliases
    def aliases
      @alias_list.respond_to?('split') ? @alias_list.split(/,\s*/) : []
    end
    
    # Factory method to return an instance from a permalink  
    def self.get(permalink)
      j = API.single_entity(permalink, self::ENT_NAME)
      e = self.new(j)
      return e
    end
    
    # Finds an entity by its name. Uses two HTTP requests; one to find the
    # permalink, and another to request the actual entity.
    def self.find(name)
      get(API.permalink({name: name}, self::ENT_PLURAL)["permalink"])
    end
    
    # Requests a list of all entities of a given type. Returns the list as an
    # array of EntityListItems.
    def self.all
      all = API.all(self::ENT_PLURAL).map do |ent|
        ent["namespace"] = self::ENT_NAME
        EntityListItem.new(ent)
      end
    end
    
    
    # Compares two objects, returning true if they have the same permalink
    # (ie, represent the same entity). If you must ensure that the two objects
    # also contain the same data, you should also compare the updated_at
    # attributes.
    def ===(other)
      @permalink == other.permalink
    end
    
  end
end
