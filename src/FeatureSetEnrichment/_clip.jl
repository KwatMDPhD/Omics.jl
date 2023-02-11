function _clip(le, pr, mi)

    le -= pr

    if le < mi

        le = mi

    end

    le

end
