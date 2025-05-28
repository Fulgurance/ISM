require "./RequiredLibraries"

Ism = ISM::CommandLine.new

begin
    if Ism.ranAsSuperUser
        Ism.printRanAsSuperUserErrorNotification
        Ism.exitProgram(code: 2)
    elsif !Ism.ranAsMemberOfIsmGroup
        Ism.printNotRanAsMemberOfIsmGroupErrorNotification
        Ism.exitProgram(code: 3)
    else
        #We set uid and gid bit to allow any time privilege escalations
        LibC.setuid(id: 0)
        #We ensure for now all will be run as ism user
        #If superuser access is needed, call: runAsSuperUser (to avoid security issues)
        LibC.setresuid( realId: ISM::Default::CommandLine::Id,
                        effectiveId: ISM::Default::CommandLine::Id,
                        savedId: 0)
        LibC.setresgid( realId: ISM::Default::CommandLine::Id,
                        effectiveId: ISM::Default::CommandLine::Id,
                        savedId: 0)

        Ism.start
    end
rescue error
    ISM::Error.show(className: "None",
                    functionName: "None",
                    errorTitle: "Unexpected error occured",
                    error: "The program stopped due to an unknown error",
                    information: "This error occur when #{ISM::Default::CommandLine::Name.upcase} is unable to catch the error",
                    errorCode: 1)
ensure
    #We ensure even we are facing an issue:
    #   -the system is locked
    #   -the terminal title is restored
    #   -uid and gid bit are unset
    Ism.lockSystemAccess
    Ism.resetTerminalTitle
    LibC.setuid(id: ISM::Default::CommandLine::Id)
    LibC.setgid(id: ISM::Default::CommandLine::Id)
    Ism.exitProgram(code: 1)
end
