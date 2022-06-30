function _make_empty_trace(ty, n_tr)

    [Dict{String, Any}("type" => ty) for _ in 1:n_tr]

end
