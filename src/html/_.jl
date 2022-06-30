module html

using DefaultApplication
using Scratch

function __init__()

    global SC = @get_scratch!("OnePiece.html")

end

include("make.jl")

end
