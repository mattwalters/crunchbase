begin
  require 'yajl'
rescue LoadError
  require 'json'
end

module Crunchbase
  class Entity

    API_BASE = 'http://api.crunchbase.com/v/2/'
    SUPPORTED_ENTITIES = [ 'person' ]

    attr_reader :available_properties, :fully_initialized

    class << self
      def entity_type
	raise NotImplementedError
      end
      def find(permalink)
	new("path" => "#{entity_type}/#{permalink}")
      end
    end

    def initialize(json)
      if json.key?("data")
	fully_initialize!(json)
      elsif json.key?("path")
	@path = json["path"]
      else
	raise("can't initialize with this json: #{json.inspect}") 
      end
    end

    def parser
      if defined?(Yajl)
        Yajl::Parser
      else
        JSON
      end
    end

    def fully_initialized?
      !! fully_initialized
    end

    def fetch_json!
      raise("path not defined") unless path
      url = API_BASE + path
      parser.parse(HTTParty.get(url).body)
    end

    def fully_initialize!(json = nil)
      json ||= fetch_json!
      @available_properties = json["data"]["properties"].keys
      json["data"]["properties"].each do |property_name, value|
	define_singleton_method(property_name) { value }
      end
      @available_relationships = json["data"]["relationships"].keys
      # set up relationship objects

      @fully_initialized = true
    end

    def method_missing(method_name, *args, &block)
      if fully_initialized?
	return super
      else
	binding.pry
	fully_initilize!
	send(method_name, *args, block)
      end
    end


  end
end
