module ISM

    module Option

        class SystemUnlock < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SystemUnlock::ShortText,
                        ISM::Default::Option::SystemUnlock::LongText,
                        ISM::Default::Option::SystemUnlock::Description)
            end

            def start
                if ARGV.size == 2
                    Ism.setSystemAccess(locked: false)
                    Ism.printProcessNotification(ISM::Default::Option::SystemUnlock::SetText)
                end
            end

        end

    end

end
