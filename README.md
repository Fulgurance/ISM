![Static Badge](https://img.shields.io/badge/License-GPL_3.0-blue)

# ISM

ISM (Ingenius System Manager) is an extremely advanced tool to build and manage a Linux system completely from scratch.
It manage the full build process of the cross toolchain, and can provide fine-grained configuration for each software.

It is possible to do any installation with or without chroot in a targeted system. As well, to configure compiler flags, number of parallel jobs, custom machine target ... etc

The software handle too the calculation of Linux kernel dependencies. That mean all of the require needed kernel features for all packages will be automatically enabled and it will reconfigure properly the kernel. It make definitely easier to configure the kernel and optimize it.

***Guide***: https://github.com/Fulgurance/ISM/wiki/Guide

![ISM-Example.png](https://www.zupimages.net/up/24/20/2mn6.png)

## Usage

You can see main functionnalities when you just type ism in a terminal:
```
user $ ism
Ingenius System Manager
        -h      help    Display the help how to use ISM
        -v      version Show and manage the ISM version
        -so     software        Install, configure and remove softwares
        -p      port    Manage ISM ports
        -se     settings        Configure ISM settings
        -d      debug   Enable debug mode to track any error
```

```
user $ ism version
Show and manage the ISM version
        -s      show    Show the current ISM version
        -sw     switch  Switch ISM to an another version
```

```
user $ ism software
Install, configure and remove softwares
        -sd     selectdependency        Select a dependency part of unique set
                                Need to be use like this:
                                ism software [softwarename] selectdependency [dependencyname]
        -do     disableoption   Disable a specific software option
                                Need to be use like this:
                                ism software [softwarename] disableoption [optionname]
        -eo     enableoption    Enable a specific software option
                                Need to be use like this:
                                ism software [softwarename] enableoption [optionname]
        -i      install Install specific(s) software(s)
        -ui     uninstall       Uninstall specific(s) software(s)
        -c      clean   Clean the system by remove unneeded softwares
        -se     search  Search specific(s) software(s)
        -sy     synchronize     Synchronize the software database
        -u      update  Performs a software update
        -ap     addpatch        Add a local patch for a specific software
                                Need to be use like this:
                                ism software [softwarename-softwareversion] addpatch [patchpath]
        -dp     deletepatch     Delete a local patch for a specific software
                                Need to be use like this:
                                ism software [softwarename-softwareversion] deletepatch [patchpath]
```

```
user $ ism port
Manage ISM ports
        -o      open    Open the specified port
        -c      close   Close the specified port
        -stv    settargetversion        Set the target version for all ports, based on a ISM version
```

```
user $ ism settings
Configure ISM settings
        -s      show    Show the current settings
        -esm    enablesecuremode        Enable the secure mode which requires superuser rights
        -dsm    disablesecuremode       Disable the secure mode which requires superuser rights
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

## About
The project is still experimental, most of the functionnalities are already implemented. It is actually possible to install a full desktop environment with the provided ports .

That is not ready at the moment for a production environment. It is actually only for test purpose.
