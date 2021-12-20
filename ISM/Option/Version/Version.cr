module ISM

    module Option

        class Version < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::Version::ShortText,
                        ISM::Default::Option::Version::LongText,
                        ISM::Default::Option::Version::Description,
                        ISM::Default::Option::Version::Options)
            end

            def start
                puts ISM::Default::CommandLine::Title
                puts    Ism.version.stage + "-" +
                        "#{Ism.version.majorVersion.colorize(:green)}" +
                        "#{".".colorize(:green)}" +
                        "#{Ism.version.minorVersion.colorize(:green)}" +
                        "#{".".colorize(:green)}" +
                        "#{Ism.version.patchVersion.colorize(:green)}"
            end

        end
        
    end

end
