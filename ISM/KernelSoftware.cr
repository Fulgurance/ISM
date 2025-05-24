module ISM

    class KernelSoftware < ISM::VirtualSoftware

        def deploy
            super

            generateKernelConfiguration
            buildKernel
            installKernel
        end

    end

end
