module Kate

for na::String in readdir(@__DIR__)
    if endswith(na, ".jl") && na != splitdir(@__FILE__)[end]

        include(na)

    end

end

end
