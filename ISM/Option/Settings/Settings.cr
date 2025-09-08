module ISM

    module Option

        class Settings < CommandLine::Option

            module Default

                ShortText = "-se"
                LongText = "settings"
                Description = "Configure ISM settings"
                Options = [ Option::Settings::Show.new,
                            #Global options
                            Option::Settings::SetRootPath.new,
                            Option::Settings::SetDefaultMirror.new,
                            Option::Settings::EnableBuildKernelOptionsAsModule.new,
                            Option::Settings::DisableBuildKernelOptionsAsModule.new,
                            Option::Settings::EnableAutoBuildKernel.new,
                            Option::Settings::DisableAutoBuildKernel.new,
                            Option::Settings::EnableAutoDeployServices.new,
                            Option::Settings::DisableAutoDeployServices.new,
                            #Host options
                            Option::Settings::SetSystemTargetArchitecture.new,
                            Option::Settings::SetSystemTargetVendor.new,
                            Option::Settings::SetSystemTargetOs.new,
                            Option::Settings::SetSystemTargetAbi.new,
                            Option::Settings::SetSystemMakeOptions.new,
                            Option::Settings::SetSystemBuildOptions.new,
                            Option::Settings::SetSystemName.new,
                            Option::Settings::SetSystemFullName.new,
                            Option::Settings::SetSystemId.new,
                            Option::Settings::SetSystemRelease.new,
                            Option::Settings::SetSystemCodeName.new,
                            Option::Settings::SetSystemDescription.new,
                            Option::Settings::SetSystemVersion.new,
                            Option::Settings::SetSystemVersionId.new,
                            Option::Settings::SetSystemAnsiColor.new,
                            Option::Settings::SetSystemCpeName.new,
                            Option::Settings::SetSystemHomeUrl.new,
                            Option::Settings::SetSystemSupportUrl.new,
                            Option::Settings::SetSystemBugReportUrl.new,
                            Option::Settings::SetSystemPrivacyPolicyUrl.new,
                            Option::Settings::SetSystemBuildId.new,
                            Option::Settings::SetSystemVariant.new,
                            Option::Settings::SetSystemVariantId.new,
                            #Chroot options
                            Option::Settings::SetChrootTargetArchitecture.new,
                            Option::Settings::SetChrootTargetVendor.new,
                            Option::Settings::SetChrootTargetOs.new,
                            Option::Settings::SetChrootTargetAbi.new,
                            Option::Settings::SetChrootMakeOptions.new,
                            Option::Settings::SetChrootBuildOptions.new,
                            Option::Settings::SetChrootName.new,
                            Option::Settings::SetChrootFullName.new,
                            Option::Settings::SetChrootId.new,
                            Option::Settings::SetChrootRelease.new,
                            Option::Settings::SetChrootCodeName.new,
                            Option::Settings::SetChrootDescription.new,
                            Option::Settings::SetChrootVersion.new,
                            Option::Settings::SetChrootVersionId.new,
                            Option::Settings::SetChrootAnsiColor.new,
                            Option::Settings::SetChrootCpeName.new,
                            Option::Settings::SetChrootHomeUrl.new,
                            Option::Settings::SetChrootSupportUrl.new,
                            Option::Settings::SetChrootBugReportUrl.new,
                            Option::Settings::SetChrootPrivacyPolicyUrl.new,
                            Option::Settings::SetChrootBuildId.new,
                            Option::Settings::SetChrootVariant.new,
                            Option::Settings::SetChrootVariantId.new]

            end

            def initialize
                super(  Default::ShortText,
                        Default::LongText,
                        Default::Description,
                        Default::Options)
            end

            def start
                if ARGV.size == 1
                    showHelp
                else
                    matchingOption = false
    
                    @options.each_with_index do |argument, index|
                        if ARGV[1] == argument.shortText || ARGV[1] == argument.longText
                            matchingOption = true
                            @options[index].start
                            break
                        end
                    end
    
                    if !matchingOption
                        puts "#{CommandLine::Default::ErrorUnknowArgument.colorize(:yellow)}" + "#{ARGV[0].colorize(:white)}"
                        puts    "#{CommandLine::Default::ErrorUnknowArgumentHelp1.colorize(:white)}" +
                                "#{CommandLine::Default::ErrorUnknowArgumentHelp2.colorize(:green)}" +
                                "#{CommandLine::Default::ErrorUnknowArgumentHelp3.colorize(:white)}"
                    end
                end
            end

        end
        
    end

end
