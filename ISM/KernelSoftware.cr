module ISM

    class KernelSoftware < ISM::Software

        def deploy
            super

            generateKernelConfiguration
            buildKernel
            installKernel
        end

    end

end
