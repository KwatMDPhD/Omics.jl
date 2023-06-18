rm -fr ../output/*

alias ju="julia --project"

alias da="date \"+%Y-%m-%d %H:%M:%S\""

echo "⏳ $(da)"

# ---------------------------------------------------------------------------------------------- #

ju ito.jl &&

# ju cluster.jl example.1 0 1.0 0 0 ../input/data/gse107011.json &&
# ju cluster.jl example.2 1 0.3 0 0 ../input/data/gse107011.json &&
# ju cluster.jl example.3 0 1.0 0 0 ../input/data/gse107011.json &&
# ju cluster.jl example.3 1 1.0 0 0 ../input/data/gse107011.json &&
# ju cluster.jl ImmuneSystem 0 1.0 -1 0 ../input/data/gse107011.json &&
# ju cluster.jl ImmuneSystem 1 1.0 -1 0 ../input/data/gse107011.json &&
# ju summarize.jl cluster gse107011 &&

# ju match.jl example.1 0 1.0 -1 0 ../input/data/gse107011.json &&
# ju match.jl example.2 1 0.3 -1 0 ../input/data/gse107011.json &&
# ju match.jl example.3 0 1.0 -1 0 ../input/data/gse107011.json &&
# ju match.jl example.3 1 1.0 -1 1 ../input/data/gse107011.json &&
# ju match.jl ImmuneSystem 0 1.0 -1 0 ../input/data/gse107011.json &&
# ju match.jl ImmuneSystem 1 1.0 -1 1 ../input/data/gse107011.json &&
# ju summarize.jl match gse107011 &&

# ju match.jl ImmuneSystem 1 1.0 -1 1 ../input/data/sdy67.json &&
# ju match.jl ImmuneSystem 1 1.0 -1 1 ../input/data/sdy67.0.json &&
# ju match.jl ImmuneSystem 1 1.0 -1 1 ../input/data/sdy67.3.json &&
# ju match.jl ImmuneSystem 1 1.0 -1 1 ../input/data/sdy67.28.json &&
# ju summarize.jl match sdy67 &&

# ju match.jl ImmuneSystem 1 1.0 -1 1 ../input/data/sdy1264.json &&
# ju match.jl ImmuneSystem 1 1.0 -1 1 ../input/data/sdy1264.0.json &&
# ju match.jl ImmuneSystem 1 1.0 -1 1 ../input/data/sdy1264.3.json &&
# ju match.jl ImmuneSystem 1 1.0 -1 1 ../input/data/sdy1264.21.json &&
# ju summarize.jl match sdy1264 &&

# ju factorize.jl ImmuneSystem 1 1.0 -1 0 ../input/data/sdy67.0.json &&
# ju factorize.jl ImmuneSystem 1 1.0 -1 0 ../input/data/sdy1264.0.json &&

# ---------------------------------------------------------------------------------------------- #

echo "⌛️ $(da)"
