module ISM

    module AI

        #Note: Threads need to be implemented properly
        Name = "Epsilon"
        ModeleFile = "gemma-2-9b-it-Q4_K_M.gguf"
        ModeleDirectory = "/modeles"
        ModelePath = "#{ModeleDirectory}/#{ModeleFile}"
        CommandPath = "/usr/bin/llama-cli"
        Prompt = "You are an assistant name #{name}, and you answer user request in polite and accurate manner"
        Parameters = "--chat-template vicuna-orca --n-predict 512 --threads 8 --ctx-size 2048 --temp 0.9 --top-k 80 --repeat-penalty 1.1 --no-display-prompt --log-disable"
        Commands = {"" => ""}

        def self.available : Bool
            return File.exists?(CommandPath)

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def self.askRequest(request : String) : String
            processResult = IO::Memory.new

            process = Process.run(  "llama-cli -m #{ModelePath} #{Parameters} -p \"#{Prompt}. user: #{request} assistant:\"",
                                    output: processResult,
                                    shell: false)

            return processResult.to_s.strip

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

    end

end
