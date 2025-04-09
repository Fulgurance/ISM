require "./RequiredLibraries"

Ism = ISM::CommandLine.new

begin
    #We check first if the user try to perform right escalating access
    tryEscalating = false

    if ISM::Core::Security.ranAsSuperUser
        tryEscalating = true
        Ism.printNeedToBeRunAsNormalUserNotification
    elsif !ISM::Core::Security.ranAsMemberOfGroupIsm
        tryEscalating = true
        Ism.printNeedToBeRunAsMemberOfIsmGroupNotification
    end

    if tryEscalating
        ISM::Core.exitProgram
    end

    Ism.start

#We catch any raised error
rescue error
    ISM::Error.show(error)

#We ensure that the program exit securely
ensure
    #We ensure that the system is locked even we are facing an issue
    if ISM::Core::Security.systemHandleUserAccess
        ISM::Core::Security.lockSystemAccess
    end

    #To finish, we reset the initial terminal title and exit with the error code 1
    ISM::Core.resetTerminalTitle
    ISM::Core.exitProgram(code: 1)
end

