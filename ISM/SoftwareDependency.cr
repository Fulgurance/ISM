module ISM

  class SoftwareDependency

    property name : String
    property version : String
    property options : Array(ISM::SoftwareOption)

    def initialize
      @name = String.new
      @version = String.new
      @options = Array(ISM::SoftwareOption).new
    end

  end

end