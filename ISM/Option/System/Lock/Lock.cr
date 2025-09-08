module ISM

    module Option

        class System

            class Lock < CommandLine::Option

                module Default

                    ShortText = "-l"
                    LongText = "lock"
                    Description = "Lock the system access"
                    SetText = "Locking manually system access"

                end

                def initialize
                    super(  Default::ShortText,
                            Default::LongText,
                            Default::Description)
                end

                def start
                    if ARGV.size == 2
                        Ism.setSystemAccess(locked: true)
                        Ism.printProcessNotification(Default::SetText)
                    end
                end

            end

        end

    end

end
