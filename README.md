![example workflow]([https://github.com/github/docs/actions/workflows/main.yml/badge.svg](https://github.com/Fulgurance/ISM/blob/master/.github/workflows/crystal.yml))

# ISM

ISM or Ingenius System Manager is an extremely advanced tool to build and manage a Linux system from scratch.
ISM is not only a tool to manage and update software. It facilitates the way to configure the system,
enable specific options for each packages, change Linux variables and settings... etc

***Guide***: https://github.com/Fulgurance/ISM/wiki/Guide

![ISM-Example.png](https://www.zupimages.net/up/23/22/wumo.png)

## Usage

You can see main functionnalities when you just type ism in a terminal:
```
user $ ism
Ingenius System Manager
        -h      help    Display the help how to use ISM
        -v      version Show and manage the ISM version
        -so     software        Install, configure and remove softwares
        -p      port    Manage ISM ports
        -sy     system  Configure the system settings
        -se     settings        Configure ISM settings
        -d      debug   Enable debug mode to track any error
```

```
user $ ism software
Install, configure and remove softwares
        -do     disableoption   Disable a specific software option
                                Need to be use like this:
                                ism software [softwarename] disableoption [optionname]
        -eo     enableoption    Enable a specific software option
                                Need to be use like this:
                                ism software [softwarename] enableoption [optionname]
        -i      install Install specific(s) software(s)
        -ui     uninstall       Uninstall specific(s) software(s)
        -se     search  Search specific(s) software(s)
        -sy     synchronize     Synchronize the software database
        -u      update  Update specified software(s)
```

```
user $ ism port
Manage ISM ports
        -o      open    Open the specified port
        -c      close   Close the specified port
        -stv    settargetversion        Set the target version for all ports, based on a ISM version
```

```
user $ ism system
Configure the system settings
        -sla    setlcall        Set the LC_ALL variable to setup the localization of specific country
```

```
user $ ism settings
Configure ISM settings
        -s      show    Show the current settings
        -eibc   enableinstallbychroot   Enable softwares install by chroot
        -dibc   disableinstallbychroot  Disable softwares install by chroot
        -srp    setrootpath     Set the default root path where to install softwares
        -sa     setarchitecture Set the default target architecture for the compiler
        -sbo    setbuildoptions Set the default CPU flags for the compiler
        -smo    setmakeoptions  Set the default parallel make jobs number for the compiler
        -ssn    setsystemname   Set the name of the future installed system
        -stn    settargetname   Set the default machine target for the compiler
        -sca    setchrootarchitecture   Set the default chroot target architecture for the compiler
        -scbo   setchrootbuildoptions   Set the default chroot CPU flags for the compiler
        -scmo   setchrootmakeoptions    Set the default chroot parallel make jobs number for the compiler
        -scsn   setchrootsystemname     Set the name of the future chroot installed system
        -sctn   setchroottargetname     Set the default chroot machine target for the compiler
        -sdm    setdefaultmirror        Set the default mirror for ISM
```

ISM is made to use all of the settings, for the compilation as well and pass all wanted arguments,
like GCC flags, number of parallels jobs, custom machine targets.

## About
It's actually highly experimental. Now with the guide, it's actually possible to build all of the Cross-Toolchain and install a full desktop environment.

Don't use that in a production environment, only in a virtual machine, except if you assume you are totally crazy (this is possible).
