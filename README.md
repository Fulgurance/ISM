![Static Badge](https://img.shields.io/badge/License-GPL_3.0-blue)
![Workflow](https://github.com/fulgurance/ism/actions/workflows/crystal.yml/badge.svg?branch=master)

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
        -sw     switch  Switch ISM to another version
```

```
user $ ism software
Install, configure and remove softwares
        -se     search  Search specific(s) software(s)
        -sy     synchronize     Synchronize the software database
        -u      update  Performs a software update
        -i      install Install specific(s) software(s)
        -ui     uninstall       Uninstall specific(s) software(s)
        -c      clean   Clean the system by remove unneeded softwares
        -sd     selectdependency        Select a dependency part of unique set
                                Need to be use like this:
                                ism software [softwarename] selectdependency [dependencyname]
        -eo     enableoption    Enable a specific software option
                                Need to be use like this:
                                ism software [softwarename] enableoption [optionname]
        -do     disableoption   Disable a specific software option
                                Need to be use like this:
                                ism software [softwarename] disableoption [optionname]
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
        -sdm    setdefaultmirror        Set the default mirror for ISM
        -sstn   setsystemtargetname     Set the default machine target for the compiler
        -ssa    setsystemarchitecture   Set the default system architecture for the compiler
        -ssmo   setsystemmakeoptions    Set the default parallel make jobs number for the compiler
        -ssbo   setsystembuildoptions   Set the default CPU flags for the compiler
        -ssn    setsystemname   Set the name of the future installed system
        -ssfn   setsystemfullname       Set the full name of the future installed system
        -ssi    setsystemid     Set the id of the future installed system
        -ssr    setsystemrelease        Set the release of the future installed system
        -sscn   setsystemcodename       Set the code name of the future installed system
        -ssd    setsystemdescription    Set the description of the future installed system
        -ssv    setsystemversion        Set the version of the future installed system
        -ssac   setsystemansicolor      Set the ANSI color of the future installed system
        -sscn   setsystemcpename        Set the CPE name of the future installed system
        -sshu   setsystemhomeurl        Set the home url of the future installed system
        -sssu   setsystemsupporturl     Set the support url of the future installed system
        -ssbru  setsystembugreporturl   Set the bug report url of the future installed system
        -ssppu  setsystemprivacypolicyurl       Set the privacy policy url of the future installed system
        -ssbi   setsystembuildid        Set the build id of the future installed system
        -ssv    setsystemvariant        Set the variant of the future installed system
        -ssvi   setsystemvariantid      Set the variant id of the future installed system
        -sctn   setchroottargetname     Set the default chroot machine target for the compiler
        -sca    setchrootarchitecture   Set the default chroot target architecture for the compiler
        -scmo   setchrootmakeoptions    Set the default chroot parallel make jobs number for the compiler
        -scbo   setchrootbuildoptions   Set the default chroot CPU flags for the compiler
        -scn    setchrootname   Set the name of the future chroot installed system
        -scfn   setchrootfullname       Set the full name of the future chroot installed system
        -sci    setchrootid     Set the id of the future chroot installed system
        -scr    setchrootrelease        Set the release of the future chroot installed system
        -sccn   setchrootcodename       Set the code name of the future chroot installed system
        -scd    setchrootdescription    Set the description of the future chroot installed system
        -scv    setchrootversion        Set the version of the future chroot installed system
        -scac   setchrootansicolor      Set the ANSI color of the future chroot installed system
        -sccn   setchrootcpename        Set the CPE name of the future chroot installed system
        -schu   setchroothomeurl        Set the home url of the future chroot installed system
        -scsu   setchrootsupporturl     Set the support url of the future chroot installed system
        -scbru  setchrootbugreporturl   Set the bug report url of the future chroot installed system
        -scppu  setchrootprivacypolicyurl       Set the privacy policy url of the future chroot installed system
        -scbi   setchrootbuildid        Set the build id of the future chroot installed system
        -scv    setchrootvariant        Set the variant of the future chroot installed system
        -scvi   setchrootvariantid      Set the variant id of the future chroot installed system
```

## About
The project is still experimental, most of the functionnalities are already implemented. It is actually possible to install a full desktop environment with the provided ports .

That is not ready at the moment for a production environment. It is actually only for test purpose.
