module ISM
  module Default
    module Option
      module SoftwareAddPatch
        ShortText            = "-ap"
        LongText             = "addpatch"
        Description          = "Add a local patch for a specific software\n\t\t\t\tNeed to be use like this:\n\t\t\t\tism software [softwarename-softwareversion] addpatch [patchpath]"
        ShowHelpDescription  = "Add a local patch for a specific software"
        ShowHelpExampleText1 = "Need to be use like this:"
        ShowHelpExampleText2 = "ism software [softwarename-softwareversion] addpatch [patchpath]"
        NoMatchFound         = "No match found with the database for "
        NoMatchFoundAdvice   = "Maybe it's needed of refresh the database?"
        Text1                = "Adding patch "
        Text2                = " for the software "
        NoFileFound1         = "The patch located at "
        NoFileFound2         = " is not found for the software "
      end
    end
  end
end
