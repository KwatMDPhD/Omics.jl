function get_download_directory()::String

    return joinpath(homedir(), "Downloads", "")

end

export get_download_directory
