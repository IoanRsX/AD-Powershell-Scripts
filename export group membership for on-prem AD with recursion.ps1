# Import the Active Directory module
Import-Module ActiveDirectory

# Specify the group identity
$groupIdentity = "Whatever.group@whateverdomain.com"  # Replace with the actual group name or identity

# Retrieve group members recursively
$groupMembers = Get-ADGroupMember -Identity $groupIdentity -Recursive |
                Where-Object { $_.objectClass -eq 'user' } |
                Get-ADUser -Properties GivenName, Surname, EmailAddress

# Create an empty array to store user details
$userDetails = @()

# Iterate through each user and extract required details
foreach ($member in $groupMembers) {
    $user = @{
        "First Name"   = $member.GivenName
        "Last Name"    = $member.Surname
        "Email Address" = $member.EmailAddress
    }
    $userDetails += New-Object PSObject -Property $user
}

# Export the user details to a CSV file
$csvFilePath = "c:\whatever\path.csv"  # Specify the path and filename for the CSV file
$userDetails | Export-Csv -Path $csvFilePath -NoTypeInformation

# Display a confirmation message
Write-Host "User details exported to $csvFilePath"