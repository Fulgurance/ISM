module ISM

  class SoftwareOption

    property name = ISM::Default::SoftwareOption::Name
    property description = ISM::Default::SoftwareOption::Description
    property active = ISM::Default::SoftwareOption::Active

    def initialize( name = ISM::Default::SoftwareOption::Name,
                    description = ISM::Default::SoftwareOption::Description,
                    active = ISM::Default::SoftwareOption::Active)
                    @name = name
                    @description = description
                    @active = active
    end

  end

end
