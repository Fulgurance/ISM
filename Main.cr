require "./RequiredLibraries"

Ism = ISM::CommandLine.new

begin
    #Allow the program to run root commands
    uidResult = LibC.setuid(0)
    gidResult = LibC.setgid(0)

    #Drop the execution privilege when the program start to avoid any privilege escalation
    euidResult = LibC.seteuid(ISM::Default::CommandLine::SystemId.to_i)
    egidResult = LibC.setegid(ISM::Default::CommandLine::SystemId.to_i)

    #We check if the program have the suid bit set
    if euidResult.negative?
        #If not, we raise an error
        #printNeedSuidBitNotification
        raise ISM::Default::Error::SuidBitNotSet
    else
        #Starting point
        Ism.start
    end

#We catch any raised error
rescue error
    ISM::Error.show(error)

#We ensure that the program exit securely
ensure
    #We ensure that the system is locked even we are facing an issue
    if Ism.systemInformation.handleUserAccess
        Ism.lockSystemAccess
    end

    #We ensure the program can't run any command as root
    LibC.setuid(ISM::Default::CommandLine::SystemId.to_i)
    LibC.setgid(ISM::Default::CommandLine::SystemId.to_i)

    #To finish, we reset the initial terminal title and exit with the error code 1
    ISM::Core.resetTerminalTitle
    ISM::Core.exitProgram(code: 1)
end

