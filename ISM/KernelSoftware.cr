module ISM

    class KernelSoftware < ISM::Software

        def prepareInstallation
            super

            prepareKernelSourcesInstallation
        end

        def install(stripFiles: false)
            super
        end

    end

end
