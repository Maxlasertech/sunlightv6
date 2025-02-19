local request = http and http.request or request
local config = 'SunlightV6' :: string
local httpservice = cloneref(game:FindService('HttpService'))
for i: number, v: string in {'newvape', 'newvape/profiles', 'newvape/games', 'newvape/assets'} do
    makefolder(v)
end

local result = request({
    Url = 'https://api.github.com/repos/maxlasertech/SunlightV6/contents',
    Method = 'GET'
})

if result.StatusCode == 200 then
    for i: number, v: table in httpservice:JSONDecode(result.Body) do
        local body = game:HttpGet(`https://raw.githubusercontent.com/maxlasertech/sunlightv6/main/{v.name}`) :: string
        if v.name == 'assets' then
            return
        end
        if not v.name:find('.lua') and body == '404: Not Found' then
            local newresult = request({
                Url = `https://api.github.com/repos/maxlasertech/SunlightV6/contents/{v.name}`,
                Method = 'GET'
            })
            if newresult.StatusCode == 200 then
                for i2: number, v2: table in httpservice:JSONDecode(newresult.Body) do
                    local request = 
                    writefile(`newvape/{v.name}/{v2.name}`, game:HttpGet(`https://raw.githubusercontent.com/maxlasertech/sunlightv6/main/{v.name}/{v2.name}`))
                end
            end
        else
            writefile(`newvape/{v.name}`, body)
        end
    end
else
    error('Failed to get {contents} path')
end

warn('installed')