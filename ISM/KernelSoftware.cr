module ISM

    class KernelSoftware < ISM::VirtualSoftware

        def deploy
            super

            cleanKernelSources
            generateKernelConfiguration
            buildKernel
            installKernel
        end

    end

end
