module ISM

  class SoftwareOption

    property name : String
    property description : String
    property active : Bool

    def initialize
      @name = String.new
      @description = String.new
      @active = false
    end

    def == (other : ISM::SoftwareOption) : Bool
      return @name == other.name && @description == other.description && @active == other.active
    end

  end

end
