module ISM

    class KernelSoftware < ISM::Software

        def prepareInstallation
            super

            prepareKernelSourcesInstallation
        end

        def install
            super(stripFiles: false)

            rescue exception
                ISM::Core::Error.show(  className: "KernelSoftware",
                                        functionName: "install",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function",
                                        exception: exception)
        end

    end

end
