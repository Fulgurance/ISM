module ISM

    module Option

        class SystemLock < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SystemLock::ShortText,
                        ISM::Default::Option::SystemLock::LongText,
                        ISM::Default::Option::SystemLock::Description)
            end

            def start
                if ARGV.size == 2
                    Ism.setSystemAccess(locked: true)
                    Ism.printProcessNotification(ISM::Default::Option::SystemLock::SetText)
                end
            end

        end

    end

end
