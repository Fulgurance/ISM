require "./RequiredLibraries"

Ism = ISM::CommandLine.new

begin
    #We check first if the user try to perform escalating access
    tryEscalatingAccess = false

    if Ism.ranAsSuperUser
        tryEscalatingAccess = true
        Ism.printNeedToBeRunAsNormalUserNotification
    elsif !Ism.ranAsMemberOfGroupIsm
        tryEscalatingAccess = true
        Ism.printNeedToBeRunAsMemberOfIsmGroupNotification
    end

    if tryEscalatingAccess
        ISM::Core.exitProgram
    end

    Ism.start

#We catch any raised error
rescue error
    ISM::Error.show(error)

#We ensure that the program exit securely
ensure
    #We ensure that the system is locked even we are facing an issue
    if Ism.systemInformation.handleUserAccess
        Ism.lockSystemAccess
    end

    #To finish, we reset the initial terminal title and exit with the error code 1
    ISM::Core.resetTerminalTitle
    ISM::Core.exitProgram(code: 1)
end

