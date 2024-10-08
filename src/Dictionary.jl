module Dictionary

using JSON: parsefile, print

using OrderedCollections: OrderedDict

using TOML: parsefile as parsefil

function rea(fi, dicttype = OrderedDict)

    endswith(fi, ".toml") ? parsefil(fi) : parsefile(fi; dicttype)

end

function writ(js, ke_va, id = 2)

    open(js, "w") do io

        print(io, ke_va, id)

    end

    js

end

end
