module ISM

    module Option

        class SoftwareSynchronize < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SoftwareSynchronize::ShortText,
                        ISM::Default::Option::SoftwareSynchronize::LongText,
                        ISM::Default::Option::SoftwareSynchronize::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                synchronizationStartingTime = Time.monotonic
                frameIndex = 0
                reverseAnimation = false
                
                print ISM::Default::Option::SoftwareSynchronize::SynchronizationTitle
                text = ISM::Default::Option::SoftwareSynchronize::SynchronizationWaitingText

                if Dir.children(ISM::Default::Path::SoftwaresDirectory).empty?
                    Dir.cd(ISM::Default::Path::SoftwaresDirectory)
                    Process.run("git",args: ["init"])
                    Process.run("git",args: [   "remote",
                                                "add",
                                                "origin",
                                                "https://github.com/Fulgurance/ISM-Softwares.git"])
                else
                    Dir.cd(ISM::Default::Path::SoftwaresDirectory)
                end

                Process.run("git",args: ["pull","origin","master"]) do
                    currentTime = Time.monotonic

                    if (currentTime - synchronizationStartingTime).milliseconds > 40
                        if frameIndex >= text.size
                            reverseAnimation = true
                        end

                        if frameIndex < 1
                            reverseAnimation = false
                        end

                        if reverseAnimation
                            print "\033[1D"
                            print " "
                            print "\033[1D"
                            frameIndex -= 1
                        end

                        if !reverseAnimation
                            print "#{text[frameIndex].colorize(:green)}"
                            frameIndex += 1
                        end

                        synchronizationStartingTime = Time.monotonic
                    end
                end

                print "#{ISM::Default::Option::SoftwareSynchronize::SynchronizationDoneText.colorize(:green)}\n"
                puts "The database is synchronized"
                    
            end

        end
        
    end

end
