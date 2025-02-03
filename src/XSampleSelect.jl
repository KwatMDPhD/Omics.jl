module XSampleSelect

using StatsBase: std

using ..Omics

function index(ro_, va, id_)

    ro_[id_], va[id_, :]

end

function select(ro_::AbstractVector{<:AbstractString}, ::Any, se_)

    # TODO: Generalize with GSEA.
    map(in(Set(se_)), ro_)

end

function select(::AbstractVector{<:AbstractString}, nu, us::Integer)

    Omics.Extreme.ge(map(std, eachrow(nu)), us)[(us + 1):end]

end

function select(vt_::AbstractVector{<:Integer}, nu, mi)

    is___ = map(un -> findall(==(un), vt_), unique(vt_))

    mi_ = map(is_ -> lastindex(is_) * mi, is___)

    map(
        vf_ -> all(iu -> mi_[iu] <= count(!isnan, view(vf_, is___[iu])), eachindex(is___)),
        eachrow(nu),
    )

end

end
