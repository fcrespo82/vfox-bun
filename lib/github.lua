local github = {}

github.__index = github
local githubSingleton = setmetatable({}, github)
githubSingleton.SOURCE_URL = "https://api.github.com/repos/oven-sh/bun/releases"
githubSingleton.RELEASES ={}

function github:convertFromGH(respInfo)
    local result = {}
    for _, release in ipairs(respInfo) do
        local version = release.tag_name:gsub("bun.v", "")
        local assets_filtered = filter_assets(release.assets)
        
        for _, asset in ipairs(assets_filtered) do
            local extracted_item = extract_data(asset)

            if result[extracted_item["Os"]] == nil then
                result[extracted_item["Os"]] = {}
            end

            if result[extracted_item["Os"]][version] == nil then
                result[extracted_item["Os"]][version] = {}
            end

            table.insert(result[extracted_item["Os"]][version], extracted_item)
        end
    end

    return result
end

function filter_assets(assets)
    local result = assets
    for i = #result, 1, -1 do
        asset = result[i]
        if string.find(asset.name, "-profile") then
            table.remove(result, i)
        elseif string.find(asset.name, "-baseline") then
            table.remove(result, i)
        elseif string.find(asset.name, "-musl") then
            table.remove(result, i)
        elseif string.find(asset.name, "SHASUMS256.txt") then
            table.remove(result, i)
        end
    end
    return result
end

function extract_data(item)
    local result = {}
    result["Url"] = item["browser_download_url"]

    result["Sum"] = ""
    result["SumType"] = ""    

    if string.find(item["name"], "windows") then
        result["Os"] = "windows"
    elseif string.find(item["name"], "darwin") then
        result["Os"] = "darwin"
    elseif string.find(item["name"], "linux") then
        result["Os"] = "linux"
    else
        result["Os"] = "Unknown"
    end
    
    if string.find(item["name"], "x64") then
        result["Arch"] = "amd64"
    elseif string.find(item["name"], "aarch64") then
        result["Arch"] = "arm64"
    else
        result["Arch"] = "Unknown"
    end

    return result
end

return githubSingleton