function _make_color_scheme(he_)

    return ColorScheme((parse(Colorant, he) for he in he_))

end

const COPL = plasma

const COPO = _make_color_scheme((
    "#636efa",
    "#ef553b",
    "#00cc96",
    "#ab63fa",
    "#ffa15a",
    "#19d3f3",
    "#ff6692",
    "#b6e880",
    "#ff97ff",
    "#fecb52",
))

const COP3 = _make_color_scheme((
    "#0508b8",
    "#1910d8",
    "#3c19f0",
    "#6b1cfb",
    "#981cfd",
    "#bf1cfd",
    "#dd2bfd",
    "#f246fe",
    "#fc67fd",
    "#fe88fc",
    "#fea5fd",
    "#febefe",
    "#fec3fe",
))

const COBI = _make_color_scheme(("#006442", "#ffffff", "#ffb61e"))

const COAS = _make_color_scheme((
    "#00936e",
    "#a4e2b4",
    "#e0f5e5",
    "#ffffff",
    "#fff8d1",
    "#ffec9f",
    "#ffd96a",
))

const COHU = _make_color_scheme(("#4b3c39", "#ffffff", "#ffddca"))

const COST = _make_color_scheme(("#ffffff", "#8c1515"))
