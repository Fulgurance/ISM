require "./RequiredLibraries"

Ism = ISM::CommandLine.new

begin
    #Allow the program to run root commands
    uidResult = LibC.setuid(0)
    gidResult = LibC.setgid(0)
    euidResult = LibC.seteuid(0)
    egidResult = LibC.setegid(0)

    #We check if the program have the suid bit set
    if LibC.geteuid.negative? || LibC.getegid.negative?
        #printNeedSuidBitNotification
        puts "Need setted bit"
    else
        #Starting point
        Ism.start
    end

ensure
    #We make sure the program can't run any command as root
    LibC.setuid(ISM::Default::CommandLine::SystemId)
    LibC.setgid(ISM::Default::CommandLine::SystemId)
    LibC.seteuid(ISM::Default::CommandLine::SystemId)
    LibC.setegid(ISM::Default::CommandLine::SystemId)
end

