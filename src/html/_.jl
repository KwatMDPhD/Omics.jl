module html

using Scratch

function __init__()

    global SC = @get_scratch!("html")

end

include("make.jl")

end
