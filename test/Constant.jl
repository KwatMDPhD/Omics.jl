include("environment.jl")

# ---- #

@test basename(BioLab.Constant.TE) == "BioLab" &&
      isdir(BioLab.Constant.TE) &&
      isempty(readdir(BioLab.Constant.TE))

# ---- #

@test BioLab.Constant.RA == 20121020

# ---- #

@test BioLab.Constant.CA_ == ['A', '2', '3', '4', '5', '6', '7', '8', '9', 'X', 'J', 'Q', 'K']
