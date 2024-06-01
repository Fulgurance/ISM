module ISM
  module Default
    module Option
      module PortSetTargetVersion
        ShortText      = "-stv"
        LongText       = "settargetversion"
        Description    = "Set the target version for all ports, based on a ISM version"
        SetTitle       = "ISM start to set the target version: "
        SetWaitingText = "Setting the target version"
        SetText        = "Setting the default target version to "
        SetTextError1  = "Impossible to target the given version:  "
        SetTextError2  = ". This version doesn't exist."
      end
    end
  end
end
