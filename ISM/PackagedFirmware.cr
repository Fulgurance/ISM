module ISM

    class PackagedFirmware < ISM::PackagedSoftware

        def deploy
            super

            runDepmodCommand("#{mainKernelVersion}")
        end

    end

end
