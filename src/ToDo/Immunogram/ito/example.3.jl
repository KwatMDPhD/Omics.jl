include("example.2.jl")

@st CD80 "re"

@st CD86 "re"

@st CD28 "re"

@st CD28_ "ca"

@st CD4CD28_ "ca"

# TODO: Fix.
(CD80, CD86, CD28) >> CD28_

(CD4_, CD28_) >> CD4CD28_

@st Th0 "tc"

Th0 >> (CD4, CD28)

@st IL12 "pr"

@st Th1 "tc"

(Th0, CD4CD28_, IL12) >> Th1

@st IL4 "pr"

@st Th2 "tc"

(Th0, CD4CD28_, IL4) >> Th2
