module ISM

    class PackagedFirmware < ISM::PackagedSoftware

        def install
            super

            runDepmodCommand
        end

    end

end
