module ISM
  module Option
    class VersionShow < ISM::CommandLineOption
      def initialize
        super(ISM::Default::Option::VersionShow::ShortText,
          ISM::Default::Option::VersionShow::LongText,
          ISM::Default::Option::VersionShow::Description,
          Array(ISM::CommandLineOption).new)
      end

      def start
        puts ISM::Default::CommandLine::Title

        processResult = IO::Memory.new

        process = Process.run("git describe --all",
          output: processResult,
          shell: true,
          chdir: "/" + ISM::Default::Path::LibraryDirectory)
        currentVersion = processResult.to_s.strip
        currentVersion = currentVersion.lchop(currentVersion[0..currentVersion.rindex("/")])

        processResult.clear

        process = Process.run("git describe --tags",
          output: processResult,
          shell: true,
          chdir: "/" + ISM::Default::Path::LibraryDirectory)
        currentTag = processResult.to_s.strip

        processResult.clear

        snapshot = (currentVersion == currentTag)

        versionPrefix = snapshot ? "Version (snapshot): " : "Version (branch): "

        if !snapshot
          process = Process.run("git rev-parse HEAD",
            output: processResult,
            shell: true,
            chdir: "/" + ISM::Default::Path::LibraryDirectory)

          currentVersion = currentVersion + "-" + processResult.to_s.strip
        end

        version = versionPrefix + "#{currentVersion.colorize(:green)}"

        puts version
      end
    end
  end
end
