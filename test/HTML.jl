using Test: @test

using Nucleus

# ---- #

const HT = joinpath(Nucleus.TE, "name.html")

# ---- #

const SR_ = ("SRC_1", "SRC_2")

# ---- #

const ID = "ID"

# ---- #

const SC = "SCRIPT"

# ---- #

Nucleus.HTML.make(HT, SR_, ID, SC)

# ---- #

@test lastindex(readlines(HT)) === 10 + lastindex(SR_)

# ---- #

for ba in ("#ff0000", "#0000ff")

    Nucleus.HTML.make("", SR_, ID, SC; ba)

end
