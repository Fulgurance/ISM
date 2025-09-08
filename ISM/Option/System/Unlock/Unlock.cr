module ISM

    module Option

        class System

            class Unlock < CommandLine::Option

                module Default

                    ShortText = "-u"
                    LongText = "unlock"
                    Description = "Unlock the system access"
                    SetText = "Unlocking manually system access"

                end

                def initialize
                    super(  Default::ShortText,
                            Default::LongText,
                            Default::Description)
                end

                def start
                    if ARGV.size == 2
                        Ism.setSystemAccess(locked: false)
                        Ism.printProcessNotification(Default::SetText)
                    end
                end

            end

        end

    end

end
