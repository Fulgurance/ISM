module ISM

    class AvailableKernel

        property name : String
        property options : Array(ISM::KernelOption)

        def initialize(@name = String.new, @options = Array(ISM::KernelOption).new)

            rescue error
            ISM::Core::Error.show(  className: "AvailableKernel",
                                    functionName: "Initialize",
                                    errorTitle: "Initialization failure",
                                    error: "Failed to initialize the class")
        end

    end

end
