# Examples :
#  $APIKey= "q.th1s1sn0tn0tmy4p1k3y"
#  $Title = "Title"
#  $Message = "Hello World"
#     Send-Pushbullet -Title $Title -Message $Message -APIKey $APIKey
#
#     Send-Pushbullet -Title "Warning: $(hostame)" -Message "My Message" -APIKey "q.th1s1sn0tn0tmy4p1k3y"

Function Send-Pushbullet {
    param([Parameter(Mandatory=$True)][string]$APIKey=$(throw "APIKey is mandatory, please provide a value."), # [Parameter(Mandatory=$False)][string]$APIKey="mykey",
          [Parameter(Mandatory=$True)][string]$Title=$(throw "Title is mandatory, please provide a value."),
          [string]$Message="",
          [string]$Link="",
          [string]$DeviceIden="",
          [string]$ContactEmail=""
    )
    
    $Body = @{ type = $(if ($Link -ne ""){"link"}else{"note"})
           title = $Title
           body = $Message
           url = $Link
           device_iden = $DeviceIden
           email = $ContactEmail
    }
    
    $Creds = New-Object System.Management.Automation.PSCredential ($APIKey, (ConvertTo-SecureString $APIKey -AsPlainText -Force))
    Invoke-WebRequest -Uri "https://api.pushbullet.com/v2/pushes" -Credential $Creds -Method Post -Body $Body | Out-Null
}
