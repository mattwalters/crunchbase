require 'date'
module Crunchbase
  class Person < Entity

    include Crunchbase::DateMethods

    class << self 
      def entity_type
	"person"
      end
    end

  end
end
