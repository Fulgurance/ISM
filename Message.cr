module ISM

  module Default

    module Message

      Banner = "#{"Ingenius System Manager".colorize(:white)}"

      HelpOption = "--#{"help".colorize(:white)}"
      HelpShortOption = "-#{"h".colorize(:white)}"
      HelpOptionDescription = "#{"Display the help how to use ISM".colorize(:green)}"

      VersionOption = "--#{"version".colorize(:white)}"
      VersionShortOption = "-#{"v".colorize(:white)}"
      VersionOptionDescription = "#{"Display the version of ISM".colorize(:green)}"

      SoftwareOption = "#{"software".colorize(:white)}"
      SoftwareOptionDescription = "#{"Install, configure and remove softwares".colorize(:green)}"

      SettingsOption = "#{"settings".colorize(:white)}"
      SettingsOptionDescription = "#{"Configure ISM settings".colorize(:green)}"

    end

  end

end
