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
                            #Host options
                            Option::Settings::SetDefaultMirror.new,
                            Option::Settings::EnableBuildKernelOptionsAsModule.new,
                            Option::Settings::DisableBuildKernelOptionsAsModule.new,
                            Option::Settings::EnableAutoBuildKernel.new,
                            Option::Settings::DisableAutoBuildKernel.new,
                            Option::Settings::EnableAutoDeployServices.new,
                            Option::Settings::DisableAutoDeployServices.new,
                            Option::Settings::SetMakeOptions.new,
                            Option::Settings::SetBuildOptions.new,
                            Option::Settings::SetSystemTargetArchitecture.new,
                            Option::Settings::SetSystemTargetVendor.new,
                            Option::Settings::SetSystemTargetOs.new,
                            Option::Settings::SetSystemTargetAbi.new,
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
                            Option::Settings::SetChrootDefaultMirror.new,
                            Option::Settings::EnableChrootBuildKernelOptionsAsModule.new,
                            Option::Settings::DisableChrootBuildKernelOptionsAsModule.new,
                            Option::Settings::EnableChrootAutoBuildKernel.new,
                            Option::Settings::DisableChrootAutoBuildKernel.new,
                            Option::Settings::EnableChrootAutoDeployServices.new,
                            Option::Settings::DisableChrootAutoDeployServices.new,
                            Option::Settings::SetChrootMakeOptions.new,
                            Option::Settings::SetChrootBuildOptions.new,
                            Option::Settings::SetChrootSystemTargetArchitecture.new,
                            Option::Settings::SetChrootSystemTargetVendor.new,
                            Option::Settings::SetChrootSystemTargetOs.new,
                            Option::Settings::SetChrootSystemTargetAbi.new,
                            Option::Settings::SetChrootSystemName.new,
                            Option::Settings::SetChrootSystemFullName.new,
                            Option::Settings::SetChrootSystemId.new,
                            Option::Settings::SetChrootSystemRelease.new,
                            Option::Settings::SetChrootSystemCodeName.new,
                            Option::Settings::SetChrootSystemDescription.new,
                            Option::Settings::SetChrootSystemVersion.new,
                            Option::Settings::SetChrootSystemVersionId.new,
                            Option::Settings::SetChrootSystemAnsiColor.new,
                            Option::Settings::SetChrootSystemCpeName.new,
                            Option::Settings::SetChrootSystemHomeUrl.new,
                            Option::Settings::SetChrootSystemSupportUrl.new,
                            Option::Settings::SetChrootSystemBugReportUrl.new,
                            Option::Settings::SetChrootSystemPrivacyPolicyUrl.new,
                            Option::Settings::SetChrootSystemBuildId.new,
                            Option::Settings::SetChrootSystemVariant.new,
                            Option::Settings::SetChrootSystemVariantId.new]

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
