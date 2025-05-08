module ISM

    class PackagedFirmware < ISM::PackagedSoftware

        def install
            super

            if commandIsAvailable("depmod")
                runDepmodCommand
            end

            rescue exception
                ISM::Core::Error.show(  className: "PackagedFirmware",
                                        functionName: "install",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function",
                                        exception: exception)
        end

    end

end
