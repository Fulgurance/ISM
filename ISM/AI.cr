module ISM

    module AI

        ModeleFile = "gemma-2-9b-it-Q4_K_M.gguf"
        ModeleDirectory = "/modeles"
        ModelePath = "#{ModeleDirectory}/#{ModeleFile}"
        Prompt = "You are an assistant call Epsilon, and you answer user request in polite and accurate manner"
        Parameters = "--chat-template vicuna-orca --n-predict 512 --threads 8 --ctx-size 2048 --temp 0.9 --top-k 80 --repeat-penalty 1.1 --no-display-prompt --log-disable"
        Commands = {"" => ""}
        #Threads need to be implemented properly

        def self.askRequest(request : String) : String
            processResult = IO::Memory.new

            process = Process.run(  "llama-cli -m #{ModelePath} #{Parameters} -p \"#{Prompt}. user: #{request} assistant:\"",
                                    output: processResult,
                                    shell: false)

            return processResult.to_s.strip
        end

    end

end
