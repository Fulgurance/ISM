module ISM

  class Option

    property name = ISM::Default::Option::Name
    property description = ISM::Default::Option::Description
    property active = ISM::Default::Option::Active

    def initialize( name = ISM::Default::Option::Name,
                    description = ISM::Default::Option::Description,
                    active = ISM::Default::Option::Active)
                    @name = name
                    @description = description
                    @active = active
    end

  end

end
