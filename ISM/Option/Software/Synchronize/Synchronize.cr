module ISM

    module Option

        class SoftwareSynchronize < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SoftwareSynchronize::ShortText,
                        ISM::Default::Option::SoftwareSynchronize::LongText,
                        ISM::Default::Option::SoftwareSynchronize::Description)
            end

            def start
                if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                    Ism.printNeedSuperUserAccessNotification
                else
                    oldPortList = Ism.ports.dump

                    print ISM::Default::Option::SoftwareSynchronize::SynchronizationTitle

                    Ism.synchronizePorts

                    #Show synchronization report

                    #New ports
                    #Deleted ports
                    #Totat port synchronized    -> Ism.ports.size
                    #Total available softwares  -> Ism.softwares.size

                    print "#{ISM::Default::Option::SoftwareSynchronize::SynchronizationDoneText.colorize(:green)}\n"
                    puts "#{ISM::Default::Option::SoftwareSynchronize::SynchronizedText.colorize(:green)}"
                end
            end

        end
        
    end

end
