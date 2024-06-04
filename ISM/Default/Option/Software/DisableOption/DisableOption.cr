module ISM
  module Default
    module Option
      module SoftwareDisableOption
        ShortText            = "-do"
        LongText             = "disableoption"
        Description          = "Disable a specific software option\n\t\t\t\tNeed to be use like this:\n\t\t\t\tism software [softwarename] disableoption [optionname]"
        ShowHelpDescription  = "Disable a specific software option"
        ShowHelpExampleText1 = "Need to be use like this:"
        ShowHelpExampleText2 = "ism software [softwarename] disableoption [optionname]"
        NoMatchFound         = "No match found with the database for "
        NoMatchFoundAdvice   = "Maybe it's needed of refresh the database?"
        SetText1             = "Disabling the option "
        SetText2             = " for the software "
        OptionNoMatchFound1  = "No matching option named "
        OptionNoMatchFound2  = " found for the software "
      end
    end
  end
end
