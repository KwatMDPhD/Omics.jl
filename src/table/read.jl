function read(pa; xl = "", ke_ar...)

    if !ispath(pa)

        error()

    end

    ex = splitext(pa)[2]

    if ex == ".xlsx"

        DataFrame(readtable(pa, xl)...)

    else

        it_ = mmap(pa)

        if ex == ".gz"

            it_ = transcode(GzipDecompressor, it_)

        end

        CSV_read(it_, DataFrame; ke_ar...)

    end

end
