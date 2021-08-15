module ISM

    class CommandLineSystemSettings

        property lcAll = ISM::Default::CommandLineSystemSettings::LcAll

        def initialize( lcAll = ISM::Default::CommandLineSystemSettings::LcAll)
            @lcAll = lcAll
        end

    end

end