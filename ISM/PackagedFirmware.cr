module ISM

    class PackagedFirmware < ISM::PackagedSoftware

        def deploy
            super

            runDepmodCommand("-w #{mainKernelVersion}")
        end

    end

end
