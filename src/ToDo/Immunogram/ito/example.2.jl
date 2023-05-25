@st Antigen "mo"

@st EndosomePeptide "pr"

@st MHC2 "re"

@st pMHC2 "re"

(EndosomePeptide, MHC2) >> pMHC2

@st Macrophage "mn"

(Macrophage, Antigen) >> EndosomePeptide

Macrophage >> MHC2

@st CD4 "re"

@st CD4_ "ca"

(pMHC2, CD4) >> CD4_
