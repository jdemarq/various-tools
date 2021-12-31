# Powershell (core) & nocodb - jdemarq
# Invoke-RestMethod with nocodb api examples

##VARS
$ncToken = "XxXxXx" # get if from nocodb webui
$ncAuthToken = "xXxXxX" # get it from nocodb webui
$ncPath = "project_a24I" #project base url
$ncHost = "http://192.168.0.XX:5058" #hostname or ip and port of nocodb server
$ncHeaders = @{
    "Content"='application/json'
    "accept" = "application/json"
    "xc-token"=$ncToken
    "xc-auth"=$ncAuthToken
}

# Return Table as an object
function get-nocodb-table ( [string]$ncHost, [string]$ncPath, [string]$ncTable, $ncHeaders, [int]$limit) {
    $Uri = "$ncHost/nc/$ncPath/api/v1/$ncTable"
    if ($limit) { $Uri = $Uri + "?limit=$limit" }
    Invoke-RestMethod -Uri $Uri -Headers $ncHeaders
}

# Add entry from file/array to a table
function update-nocodb-table-from-file ( [string]$ncHost, [string]$ncPath, [string]$ncTable, $ncHeaders, [string]$JsonPath, [string]$CsvPath, [string]$srcObject ) {
    if ($JsonPath) { $Upd = (Get-Content $JsonPath | ConvertFrom-Json) }
    elseif ($CsvPath) { $Upd = (Get-Content $CsvPath | ConvertFrom-Csv) }
    elseif ($srcObject) { $Upd = $srcObject }
    # if source colums don't match table columns, do a $Upd|select... before sending request 
    # if columns needs rename, do a $Upd|select @{L="newname";E={$_.oldname}}, ...
    $Uri = "$ncHost/nc/$ncPath/api/v1/$ncTable"
    foreach ($u in $Upd){
        Invoke-RestMethod -Uri $Uri -Headers $ncHeaders -Method POST -Body $($u|ConvertTo-Json) -ContentType "application/json; charset=utf-8"
    }
}

# get 'shopping' table
get-nocodb-table -ncHost $ncHost -ncPath $ncPath -ncTable "shopping" -ncHeaders $ncHeaders -limit 1000 | FT
# get programs
get-nocodb-table -ncHost $ncHost -ncPath $ncPath -ncTable "programs" -ncHeaders $ncHeaders -limit 200 | FT
# import json to table
update-nocodb-table-from-file  -ncHost $ncHost -ncPath $ncPath -ncTable "programs" -ncHeaders $ncHeaders -JsonPath "/mnt/import/programs.json"
