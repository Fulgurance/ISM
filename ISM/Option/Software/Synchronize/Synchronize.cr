module ISM

    module Option

        class SoftwareSynchronize < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SoftwareSynchronize::ShortText,
                        ISM::Default::Option::SoftwareSynchronize::LongText,
                        ISM::Default::Option::SoftwareSynchronize::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    #if Dir.children("ISM-Softwares").reject!(&.starts_with?(".git")).empty?

                    if Dir.children(ISM::Default::Path::SoftwaresDirectory).empty?
                        Dir.cd(ISM::Default::Path::SoftwaresDirectory)
                        Process.run("git",args: ["init"],output: :inherit)
                        Process.run("git",args: [   "remote",
                                                    "add",
                                                    "origin",
                                                    "https://github.com/Fulgurance/ISM-Softwares.git"],output: :inherit)
                        Process.run("git",args: ["pull","origin","master"],output: :inherit)
                    else
                        Dir.cd(ISM::Default::Path::SoftwaresDirectory)
                        Process.run("git",args: ["pull","origin","master"],output: :inherit)
                    end
                    
                end
            end

        end
        
    end

end
