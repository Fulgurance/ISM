module ISM

    class PackagedFirmware < ISM::PackagedSoftware

        def install
            super

            if commandIsAvailable("depmod")
                runDepmodCommand
            end
        end

    end

end
