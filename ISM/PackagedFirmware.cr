module ISM

    class PackagedFirmware < ISM::PackagedSoftware

        def install
            super

            runDepmodCommand("-w #{mainKernelVersion}")
        end

    end

end
