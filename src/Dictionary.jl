module Dictionary

using JSON: parsefile, print

using OrderedCollections: OrderedDict

using TOML: parsefile as parsefil

function rea(fi, dicttype = OrderedDict; ke_ar...)

    endswith(fi, ".toml") ? parsefil(fi; ke_ar...) : parsefile(fi; dicttype, ke_ar...)

end

function writ(js, ke_va, id = 2)

    open(js, "w") do io

        print(io, ke_va, id)

    end

    js

end

end
