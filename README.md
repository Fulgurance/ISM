# ISM

ISM or Ingenius System Manager is an extremely advanced tool to build and manage a Linux system from scratch.
ISM is not only a tool to manage and update software. It facilitates the way to configure the system,
enable specific options for each packages, change Linux variables and settings... etc

***Guide***: https://github.com/Fulgurance/ISM/wiki/Guide

[![ISM-Example.png](https://i.postimg.cc/TPHfNz6x/ISM-Example.png)](https://postimg.cc/f3XGJgyq)

## Usage

You can see main functionnalities when you just type ism in a terminal:
```
user $ ism
Ingenius System Manager
        -h      help    Display the help how to use ISM
        -v      version Display the ISM version
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
        -r      remove  Remove specific(s) software(s)
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
        -sa     setarchitecture Set the default target architecture for the compiler
        -sbo    setbuildoptions Set the default CPU flags for the compiler
        -smo    setmakeoptions  Set the default parallel make jobs number for the compiler
        -srp    setrootpath     Set the default root path where to install softwares
        -ssn    setsystemname   Set the name of the future installed system
        -stn    settargetname   Set the default machine target for the compiler
```

ISM is made to use all of the settings, for the compilation as well and pass all wanted arguments,
like GCC flags, number of parallels jobs, custom machine targets.

## About
It's actually highly experimental. Now with the guide, it's actually possible to build the Cross-Toolchain and all of the Temporary Tools of the LFS book.
Don't use that in a production environment, only in a virtual machine, except if you assume you are totally crazy (this is possible).
