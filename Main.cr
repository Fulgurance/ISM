require "./RequiredLibraries"

Ism = ISM::CommandLine.new

begin
    if ISM::Core::Security.ranAsSuperUser
        ISM::Core::Notification.ranAsSuperUserError
        Ism.exitProgram(code: 2)
    elsif !ISM::Core::Security.ranAsMemberOfIsmGroup
        ISM::Core::Notification.notRanAsMemberOfIsmGroupError
        Ism.exitProgram(code: 3)
    else
        #We set uid and gid bit to allow any time privilege escalations
        LibC.setuid(id: 0)
        #We ensure for now all will be run as ism user
        #If superuser access is needed, call: runAsSuperUser (to avoid security issues)
        LibC.setresuid( realId: ISM::Core::Security::Default::Id,
                        effectiveId: ISM::Core::Security::Default::Id,
                        savedId: 0)
        LibC.setresgid( realId: ISM::Core::Security::Default::Id,
                        effectiveId: ISM::Core::Security::Default::Id,
                        savedId: 0)

        Ism.start
    end
rescue error
    ISM::Error.show(className: "None",
                    functionName: "None",
                    errorTitle: "Unexpected error occured",
                    error: "The program stopped due to an unknown error",
                    information: "This error occur when #{ISM::CommandLine::Default::Name.upcase} is unable to catch the error",
                    errorCode: 1)
ensure
    #We ensure even we are facing an issue:
    #   -the system is locked
    #   -the terminal title is restored
    #   -uid and gid bit are unset
    Ism.lockSystemAccess
    Ism.resetTerminalTitle
    LibC.setuid(id: ISM::Core::Security::Default::Id)
    LibC.setgid(id: ISM::Core::Security::Default::Id)
    Ism.exitProgram(code: 1)
end
