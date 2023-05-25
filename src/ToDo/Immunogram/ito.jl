include("_.jl")

# ---- #

ou = make_output_directory(@__FILE__)

# ---- #

hi = 800

# ---- #

for it in ("example.1", "example.2", "example.3", "ImmuneSystem")

    include_ito(it; hi, wi = hi * Base.MathConstants.golden, ou)

end

# ---- #

push!(ST_, Dict("selector" => ".noh", "style" => Dict("label" => "data(id)")))

include_ito("legend"; hi, ou)
