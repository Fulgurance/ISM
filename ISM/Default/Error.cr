module ISM

    module Default

        module Error

            Title = "Internal error"
            InstallerTitle = "Installer failure"
            Help = "#{ISM::Default::CommandLine::Name.upcase} raised that error because the ran script did not call properly a system command or the system command itself need to be fix."
            SystemCommandFailure = "The following system command failed to run: "

        end

    end

end
