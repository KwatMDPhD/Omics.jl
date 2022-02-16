function make_empty_trace(ty, n_tr)

    [Dict{String, Any}("type" => ty) for id in 1:n_tr]

end
