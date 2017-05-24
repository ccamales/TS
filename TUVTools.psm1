function Get-GRCUsers {
[cmdletbinding()]
param(
    [parameter(
        ValueFromPipeline=$True,
        Mandatory=$True
    )]
    [int]$days
)
    $date=(Get-DAte).adddays($days)
    $sb1="OU=_Users,OU=Locations,OU=US-GRC,DC=us001,DC=itgr,DC=net"
    $results=Get-ADUser -SearchBase $sb1 -Filter {created -gt $date} -Properties created | select name, created, objectguid
    $results

    
}



function Get-ARISEUsers {
[cmdletbinding()]
param(
    [parameter(
        ValueFromPipeline=$True,
        Mandatory=$True
    )]
    [int]$days
)
    $date=(Get-DAte).adddays($days)
    $sb2="OU=_Users,OU=Locations,OU=US-ARISE,DC=us001,DC=itgr,DC=net"   
    $results=Get-ADUser -SearchBase $sb2 -Filter {created -gt $date} -Properties created | select name, created, objectguid
    $results  
}


function Get-TUVUsers {
[cmdletbinding()]
param(
    [parameter(
        ValueFromPipeline=$True,
        Mandatory=$True
    )]
    [int]$days
)
    $date=(Get-DAte).adddays($days)
    #$sb1="OU=_Users,OU=Locations,OU=US-GRC,DC=us001,DC=itgr,DC=net"
    $results=Get-ADUser -Filter {created -gt $date} -Properties created, description, emailaddress | 
        select name, samaccountname, created, Emailaddress, description, distinguishedname, objectguid
    $results

    
}


function Get-TUVComputers {
[cmdletbinding()]
param(
    [parameter(
        ValueFromPipeline=$True,
        Mandatory=$True
    )]
    [int]$days
)
    $date=(Get-DAte).adddays($days)
    #$sb1="OU=_Users,OU=Locations,OU=US-GRC,DC=us001,DC=itgr,DC=net"
    $results=Get-ADcomputer -Filter {created -gt $date} -Properties created, description | 
        select name, created, description, distinguishedname, objectguid
    $results

    
}


function Get-LockedUsers {
[cmdletbinding()]
param(
    [parameter(
        ValueFromPipeline=$True,
        Mandatory=$True
    )]
    [string]$computer
)
    $cred=(Get-Credential)

    icm -ComputerName $computer -ScriptBlock {$date=(get-date).adddays(-1);get-eventlog security -InstanceId 4740 -After $date | 
        select timegenerated, machinename, replacementstrings | 
        sort replacementstrings} -Credential $cred
    
}