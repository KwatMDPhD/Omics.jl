function symbolize(ke_va)

    Base.Dict(Symbol(ke) => va for (ke, va) in ke_va)

end
