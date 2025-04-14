require "./RequiredLibraries"

Ism = ISM::CommandLine.new

begin
    #We check first if the user try to perform right escalating access
    tryEscalating = false

    if ISM::Core::Security.ranAsSuperUser
        tryEscalating = true
        ISM::Core::Notification.needToBeRunAsNormalUserNotification
    elsif !ISM::Core::Security.ranAsMemberOfGroupIsm
        tryEscalating = true
        ISM::Core::Notification.needToBeRunAsMemberOfIsmGroupNotification
    end

    if tryEscalating
        ISM::Core.exitProgram
    end

    Ism.start

#We catch any raised error
rescue error
    ISM::Core::Error.show(  className: "None",
                            functionName: "None",
                            errorTitle: "Unexpected error occured",
                            error: "The program stopped due to an unknown error",
                            exception: error,
                            information: "This error occur when #{ISM::Default::CommandLine::Name.upcase} is unable to catch the error",
                            errorCode: 1)

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

