# Import the Active Directory module (only if needed, couldn't be bothered to include a check if it's already present)
Import-Module ActiveDirectory

# Specify the group identity (this is hardcoded, too lazy to include a prompt)
$groupIdentity = "whatever.group@whateverdomain.com"  # Replace with the actual gorup name or identity (can also be ObjectID if you wanna get fancy)

# Retrieve group members recursively and we look for properties of each AD user (in this case Given Name, Surname, Email - replace with any other properties from Get-ADUser)
$groupMembers = Get-ADGroupMember -Identity $groupIdentity -Recursive |
                Where-Object { $_.objectClass -eq 'user' } |
                Get-ADUser -Properties GivenName, Surname, EmailAddress

# Create an empty array to store user details 
$userDetails = @()

# Iterate through each user and extract required details and structure the upcominfg .csv export from that array
foreach ($member in $groupMembers) {
    $user = @{
        "First Name"   = $member.GivenName
        "Last Name"    = $member.Surname
        "Email Address" = $member.EmailAddress

# Create a new PSObject to store our structured data for each user
    }
    $userDetails += New-Object PSObject -Property $user
}

# Export the user details to a CSV file - change the file path to whatever floats your boat 
$csvFilePath = "c:\whatever\GroupUserDetails.csv"  
$userDetails | Export-Csv -Path $csvFilePath -NoTypeInformation

# Display a confirmation message
Write-Host "User details exported to $csvFilePath"
