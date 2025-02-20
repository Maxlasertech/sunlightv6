local request = http and http.request or request
local config = 'SunlightV6' :: string
local httpservice = cloneref(game:FindService('HttpService'))

local writefile = function(file: string, code: string)
    local folders = file:split('/') :: table
    local decoyfolder = {} :: table
    if (#folders - 1) > 0 then
        for i = 1, (#folders - 1) do
            if not isfolder(folders[i]) then
                makefolder(`{table.concat(decoyfolder, '/')}/{folders[i]}`)
                warn('made '.. folders[i])
                table.insert(decoyfolder, folders[i])
            end
        end
    end
    return getgenv().writefile(file, code)
end

local result = request({
    Url = 'https://api.github.com/repos/maxlasertech/sunlightv6/contents/config',
    Method = 'GET'
})

if result.StatusCode == 200 then
    for i: number, v: table in httpservice:JSONDecode(result.Body) do
        local body = request({
            Url = `https://raw.githubusercontent.com/maxlasertech/sunlightv6/main/config/{v.name}`,
            Method = 'GET'
        }) :: table
        if v.name == 'assets' then
            return
        end
        if not v.name:find('.lua') and body.StatusCode ~= 200 then
            local newresult = request({
                Url = `https://api.github.com/repos/maxlasertech/sunlightv6/contents/config/{v.name}`,
                Method = 'GET'
            })
            if newresult.StatusCode == 200 then
                for i2: number, v2: table in httpservice:JSONDecode(newresult.Body) do
                    writefile(`newvape/{v.name}/{v2.name}`, game:HttpGet(`https://raw.githubusercontent.com/maxlasertech/sunlightv6/main/config/{v.name}/{v2.name}`))
                end
            end
        else
            writefile(`newvape/{v.name}`, body.Body)
        end
    end
else
    error('Failed to get {contents} path')
end

warn('installed')