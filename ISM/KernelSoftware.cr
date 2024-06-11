module ISM

    class KernelSoftware < ISM::Software

        def prepareInstallation
            super

            prepareKernelSourcesInstallation
        end

    end

end
