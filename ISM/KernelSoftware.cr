module ISM

    class KernelSoftware < ISM::Software

        def prepareInstallation
            super

            prepareKernelSourcesInstallation
        end

        def install
            super(stripFiles: false)
        end

    end

end
