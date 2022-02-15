TE = joinpath(tempdir(), "OnePiece.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed ", TE, ".")

end

mkdir(TE)

println("Made ", TE, ".")

using OnePiece

ra_ = collect(1:10)

for va in [1, 2, 9, 10]

    println("="^99)

    println(va)

    for si in ["<", ">"]

        println("-"^99)

        println(si)

        println(OnePiece.informatics.significance.get_p_value(va, ra_, si))

    end

end

pv_ = [0.001, 0.01, 0.03, 0.5]

n_te = 6

;

for me in ["bonferroni", "benjamini_hochberg"]

    println("-"^99)

    println(me)

    println(OnePiece.informatics.significance.adjust_p_value(pv_; me = me))

    println(OnePiece.informatics.significance.adjust_p_value(pv_, n_te; me = me))

end

pv_ = [0.005, 0.009, 0.019, 0.022, 0.051, 0.101, 0.361, 0.387]

pva_ = [0.036, 0.036, 0.044, 0.044, 0.082, 0.135, 0.387, 0.387]

@assert all(pva_ .== round.(OnePiece.informatics.significance.adjust_p_value(pv_); digits = 3))

for n_pv in [2, 4, 8, 10]

    println("-"^99)

    local pv_ = collect(range(0.001, 1; length = n_pv))

    println(pv_)

    println(OnePiece.informatics.significance.adjust_p_value(pv_))

end

fl_ = [0, 1, 8, 9]

ra_ = collect(0:9)

for si in ["<", ">"]

    println(OnePiece.informatics.significance.get_p_value_and_adjust(fl_, ra_, si))

end

println(OnePiece.informatics.significance.get_p_value_and_adjust(fl_, ra_))

for po in 0:8

    println("-"^99)

    n_po = 10^po

    println(n_po)

    println(OnePiece.informatics.significance.get_margin_of_error(randn(n_po)))

end

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed ", TE, ".")

end
