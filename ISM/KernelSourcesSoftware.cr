module ISM

    class KernelSourcesSoftware < ISM::Software

        def prepareInstallation
            super

            prepareKernelSourcesInstallation
        end

        def install
            super(stripFiles: false)

            recordSelectedKernel
            updateKernelSymlinks
            updateKernelOptionsDatabase
        end

    end

end
