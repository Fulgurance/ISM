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
    Ism.lockSystemAccess
    Ism.resetTerminalTitle
    Ism.exitProgram(code: 1)
end
