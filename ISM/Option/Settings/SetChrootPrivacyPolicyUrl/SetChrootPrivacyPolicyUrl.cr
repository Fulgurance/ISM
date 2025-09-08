module ISM

    module Option

        class Settings

            class SetChrootPrivacyPolicyUrl < CommandLine::Option

                module Default

                    ShortText = "-scppu"
                    LongText = "setchrootprivacypolicyurl"
                    Description = "Set the privacy policy url of the future chroot installed system"
                    SetText = "Setting the chroot system privacy policy url to the value "

                end

                def initialize
                    super(  Default::ShortText,
                            Default::LongText,
                            Default::Description)
                end

                def start
                    if ARGV.size == 2
                        showHelp
                    else
                        Ism.settings.setChrootPrivacyPolicyUrl(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
