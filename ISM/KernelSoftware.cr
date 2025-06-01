module ISM

    class KernelSoftware < ISM::VirtualSoftware

        def deploy
            super

            if autoBuildKernel
                cleanKernelSources
                generateKernelConfiguration
                buildKernel
                installKernel
            end
        end

    end

end
