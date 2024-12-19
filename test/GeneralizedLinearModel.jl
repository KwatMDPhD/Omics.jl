using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

# ---- #

function make_sample(us)

    map(id -> "Sample $id", 1:us)

end

# ---- #

function sor(sa_, ta_, fe_)

    id_ = sortperm(fe_)

    sa_[id_], ta_[id_], fe_[id_]

end

# ---- #

for (ta_, fe_, re) in (
    (
        [1, 0, 1, 0, 1, 0],
        [2, 0, 2, 0, 2, 0],
        [
            2.3504627745014825e-8,
            2.646552652540957e-5,
            0.02893859040955415,
            0.9710614095904461,
            0.9999735344734746,
            0.9999999764953722,
        ],
    ),
    (
        [0, 1, 0, 1, 0, 1],
        [2, 0, 2, 0, 2, 0],
        [
            0.9999999764953722,
            0.9999735344734746,
            0.9710614095904458,
            0.02893859040955395,
            2.6465526525409333e-5,
            2.350462774501466e-8,
        ],
    ),
)

    up = lastindex(ta_)

    sa_, ta_, fe_ = sor(make_sample(up), ta_, fe_)

    pr_, lo_, up_ = Omics.GeneralizedLinearModel.predic(Omics.GeneralizedLinearModel.fit(ta_, fe_), Omics.Grid.make(fe_, up))

    @test pr_ == re

    Omics.GeneralizedLinearModel.plot("", "Sample", sa_, "Target", ta_, "Feature", fe_, pr_, lo_, up_; si = 16)

end

# ---- #

for ur in (10, 100, 1000)

    sa_, ta_, fe_ = sor(make_sample(ur), rand((0, 1), ur), randn(ur))

    pr_, lo_, up_ = Omics.GeneralizedLinearModel.predic(Omics.GeneralizedLinearModel.fit(ta_, fe_), Omics.Grid.make(fe_, ur))

    Omics.GeneralizedLinearModel.plot("", "Sample", sa_, "Target", ta_, "Feature", fe_, pr_, lo_, up_)

end
