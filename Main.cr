require "./RequiredLibraries"

Ism = ISM::CommandLine.new

begin
    #Allow the program to run root commands
    uidResult = LibC.setuid(0)
    euidResult = LibC.seteuid(ISM::Default::CommandLine::SystemId.to_i)
    gidResult = LibC.setgid(0)
    egidResult = LibC.setegid(ISM::Default::CommandLine::SystemId.to_i)

    #We check if the program have the suid bit set
    if euidResult.negative?
        #printNeedSuidBitNotification
        puts "Need setted bit"
    else
        #Starting point
        Ism.start
    end

ensure
    #We make sure the program can't run any command as root
    LibC.setuid(ISM::Default::CommandLine::SystemId.to_i)
    LibC.seteuid(ISM::Default::CommandLine::SystemId.to_i)
    LibC.setgid(ISM::Default::CommandLine::SystemId.to_i)
    LibC.setegid(ISM::Default::CommandLine::SystemId.to_i)
end

