include("_.jl")

# --------------------------------------------- #

n = 4

fi = "Vegapunk.tsv"

# TODO: `@test`.
println(BioLab.Gene._path(fi))

# @code_warntype BioLab.Gene._path(fi)

# 70.526 ns (4 allocations: 200 bytes)
# @btime BioLab.Gene._path($fi)

# --------------------------------------------- #

mo = BioLab.Gene.read_mouse()

# TODO: `@test`.
display(mo)

# @code_warntype BioLab.Gene.read_mouse()

# --------------------------------------------- #

mo_na = BioLab.Gene.map_mouse(mo)

# TODO: `@test`.
BioLab.Dict.print(mo_na; n)

# @code_warntype BioLab.Gene.map_mouse(mo)

# 21.200 ms (672292 allocations: 31.57 MiB)
# @btime BioLab.Gene.map_mouse($mo)

# --------------------------------------------- #

en = BioLab.Gene.read_ensembl()

# TODO: `@test`.
display(en)

# @code_warntype BioLab.Gene.read_ensembl()

# --------------------------------------------- #

en_na = BioLab.Gene.map_ensembl(en)

# TODO: `@test`.
BioLab.Dict.print(en_na; n)

# @code_warntype BioLab.Gene.map_ensembl(en)

# 5.494 s (77690449 allocations: 4.40 GiB)
# @btime BioLab.Gene.map_ensembl($en)

# --------------------------------------------- #

hg = BioLab.Gene.read_hgnc()

# TODO: `@test`.
display(hg)

# @code_warntype BioLab.Gene.read_hgnc()

# --------------------------------------------- #

hg_na = BioLab.Gene.map_hgnc(hg)

# TODO: `@test`.
BioLab.Dict.print(hg_na; n)

# @code_warntype BioLab.Gene.map_hgnc(hg)

# 58.506 ms (1032576 allocations: 45.22 MiB)
# @btime BioLab.Gene.map_hgnc($hg)

# --------------------------------------------- #

na_, ma_ = BioLab.Gene.rename(unique(skipmissing(en[!, "Gene name"])), mo_na, hg_na)

@test count(ma == 1 for ma in ma_) == 39060 &&
      count(ma == 2 for ma in ma_) == 511 &&
      count(ma == 3 for ma in ma_) == 80

na_, ma_ = BioLab.Gene.rename(unique(skipmissing(hg[!, "symbol"])), mo_na, en_na)

@test count(ma == 1 for ma in ma_) == 39133 &&
      count(ma == 2 for ma in ma_) == 310 &&
      count(ma == 3 for ma in ma_) == 3683

# TODO: Use better genes.
st_ = unique(skipmissing(en[!, "Gene name"]))

# @code_warntype BioLab.Gene.rename(st_, mo_na, hg_na, en_na)

# 660.254 ms (3464004 allocations: 152.50 MiB) 
# @btime BioLab.Gene.rename($st_, $mo_na, $hg_na, $en_na; pr = $false)

# --------------------------------------------- #

un = BioLab.Gene.read_uniprot()

# TODO: `@test`.
display(un)

# @code_warntype BioLab.Gene.read_uniprot()

# --------------------------------------------- #

pr_io_an = BioLab.Gene.map_uniprot(un)

# TODO: `@test`.
BioLab.Dict.print(pr_io_an; n)

# @code_warntype BioLab.Gene.map_uniprot(un)

# 64.899 ms (1278540 allocations: 78.12 MiB)
# @btime BioLab.Gene.map_uniprot($un)
