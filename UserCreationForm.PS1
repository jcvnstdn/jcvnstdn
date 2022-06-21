##############################
#Created by Jaco van Staden
#https://jcvnstdn.wordpress.com

#This form was created to simplify AD User creation for one of my clients.

#I know there a heaps of ways to actually correctly code this, but asking for help online is like getting stabbed in the face. Always some Fnut critisizing and 
#not actually providing feedback or help.

#So I made this with trial and error and managed to get it working. 
##############################




[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')

#Password generator
$chars = "123456789abcdefghijkmnop123456789qrstuvwxyz!#@ABCEFGHJKLMNPQRSTUVWXYZ".ToCharArray()
$newPassword=""
#change the number to length of password you want
1..8 | ForEach {  $newPassword += $chars | Get-Random };


#the form - change the title, checkboxes textboxes etc...
[xml]$XAML = @"

<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
#Rename the Form and Customize the labels and Names to Suit your needs
        Title="Company User Creation" MaxHeight="560" Width="470" ResizeMode="NoResize">
    <Grid>
        <Label Name="fnlabel" Content="First Name" HorizontalAlignment="Left" Margin="23,24,0,0" VerticalAlignment="Top"/>
        <Label Name="lnlabel" Content="Last Name" HorizontalAlignment="Left" Margin="179,24,0,0" VerticalAlignment="Top"/>
        <TextBox Name="fntxt" HorizontalAlignment="Left" Margin="27,50,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="120"/>
        <TextBox Name="lntxt" HorizontalAlignment="Left" Margin="183,50,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="120"/>
        <Label Name="samlabel" Content="Logon Name" HorizontalAlignment="Left" Margin="23,70,0,0" VerticalAlignment="Top"/>
        <TextBox Name="samtxt" HorizontalAlignment="Left" Margin="27,96,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="120"/>
        <Label Name="tllabel" Content="Title" HorizontalAlignment="Left" Margin="23,114,0,0" VerticalAlignment="Top"/>
        <TextBox Name="tltxt" HorizontalAlignment="Left" Margin="27,140,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="120"/>
        <Label Name="mblabel" Content="Mobile" HorizontalAlignment="Left" Margin="23,160,0,0" VerticalAlignment="Top"/>
        <TextBox Name="mbtxt" HorizontalAlignment="Left" Margin="27,187,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="120"/>
        <Button Name="Submit" Content="Submit" HorizontalAlignment="Left" Margin="236,464,0,0" VerticalAlignment="Top"/>
        <Button Name="Close" Content="Close" HorizontalAlignment="Left" Margin="189,464,0,0" VerticalAlignment="Top"/>
        <TextBox Name="pwtxt" Text="$newPassword" HorizontalAlignment="Left" Margin="183,96,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="120"/>
		<Label Content="Preferred Password but you can Change it" HorizontalAlignment="Left" Margin="301,94,0,0" VerticalAlignment="Top" FontSize="8"/>
        <Label Name="pwlabel" Content="Password" HorizontalAlignment="Left" Margin="179,70,0,0" VerticalAlignment="Top"/>
        <Label Name="dplabel" Content="Display Name" HorizontalAlignment="Left" Margin="179,114,0,0" VerticalAlignment="Top"/>
        <TextBox Name="dptxt" HorizontalAlignment="Left" Margin="183,140,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="120"/>
        <Label Name="emlabel" Content="Email Address" HorizontalAlignment="Left" Margin="23,207,0,0" VerticalAlignment="Top"/>
        <TextBox Name="emtxt" HorizontalAlignment="Left" Margin="27,233,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="200"/>
        <Label Content="Drive Access" HorizontalAlignment="Left" Margin="22,255,0,0" VerticalAlignment="Top" FontWeight="Bold"/>
        <CheckBox Name="grpbxgen" Content="General" HorizontalAlignment="Left" Margin="27,280,0,0" VerticalAlignment="Top"/>
        <CheckBox Name="grpbxprod" Content="Production" HorizontalAlignment="Left" Margin="27,300,0,0" VerticalAlignment="Top"/>
        <CheckBox Name="grpbxhs" Content="Health and Safety" HorizontalAlignment="Left" Margin="307,300,0,0" VerticalAlignment="Top"/>
        <CheckBox Name="grpbxfac" Content="Facts" HorizontalAlignment="Left" Margin="164,320,0,0" VerticalAlignment="Top"/>
        <CheckBox Name="grpbxsm" Content="Sales and Marketing" HorizontalAlignment="Left" Margin="307,280,0,0" VerticalAlignment="Top"/>
        <CheckBox Name="grpbxqc" Content="Quality Control" HorizontalAlignment="Left" Margin="27,320,0,0" VerticalAlignment="Top"/>
        <CheckBox Name="grpbxqa" Content="Quality Assurance" HorizontalAlignment="Left" Margin="164,300,0,0" VerticalAlignment="Top"/>
        <CheckBox Name="grpbxrd" Content="RnD" HorizontalAlignment="Left" Margin="164,280,0,0" VerticalAlignment="Top"/>
        <Label Content="Security Permissions" HorizontalAlignment="Left" Margin="22,345,0,0" VerticalAlignment="Top" FontWeight="Bold"/>
        <CheckBox Name="grpbxvpn" Content="VPN" HorizontalAlignment="Left" Margin="27,370,0,0" VerticalAlignment="Top"/>
        <CheckBox Name="grpbxla" Content="Local Admin" HorizontalAlignment="Left" Margin="27,390,0,0" VerticalAlignment="Top"/>
        <CheckBox Name="grpbx365" Content="365 Group A" HorizontalAlignment="Left" Margin="164,370,0,0" VerticalAlignment="Top"/>
    </Grid>
</Window>


"@
#Read XAML
$reader=(New-Object System.Xml.XmlNodeReader $xaml) 
try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch{Write-Host "Unable to load Windows.Markup.XamlReader"; exit}

# Store Form Objects In PowerShell and Import AD
$xaml.SelectNodes("//*[@Name]") | ForEach-Object {Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)}
Import-Module ActiveDirectory

#close button
$Close.Add_Click({$Form.Close()})

#Create new user from submitted info
$Submit.Add_Click({
 New-ADUser `
-Name $dptxt.Text`
-EmailAddress $emtxt.text `
-DisplayName $dptxt.Text`
-SamAccountName $samtxt.text `
-UserPrincipalName $emtxt.text `
-GivenName $fntxt.text `
-Surname $lntxt.Text `
-Description $tltxt.text `
-MobilePhone $mbtxt.text `
-path 'OU=Users,OU=Company,DC=local';

#specify AD groups and match to form checkboxes 
if ($grpbxgen.isChecked){
Add-ADGroupMember -Identity "ADGroup 1" -Members $samtxt.text
}

if ($grpbxprod.isChecked){
Add-ADGroupMember -Identity "ADGroup 1" -Members $samtxt.text
}

if ($grpbxhs.isChecked){
Add-ADGroupMember -Identity "ADGroup 1" -Members $samtxt.text
}

if ($grpbxfac.isChecked){
Add-ADGroupMember -Identity "ADGroup 2" -Members $samtxt.text
}

if ($grpbxsm.isChecked){
Add-ADGroupMember -Identity "ADGroup 2" -Members $samtxt.text
}

if ($grpbxqc.isChecked){
Add-ADGroupMember -Identity "ADGroup 3" -Members $samtxt.text
}

if ($grpbxqa.isChecked){
Add-ADGroupMember -Identity "ADGroup 4" -Members $samtxt.text
}

if ($grpbxrd.isChecked){
Add-ADGroupMember -Identity "ADGroup 5" -Members $samtxt.text
}

if ($grpbxvpn.isChecked){
Add-ADGroupMember -Identity "ADGroup 6" -Members $samtxt.text
}

if ($grpbxla.isChecked){
Add-ADGroupMember -Identity "ADGroup 7" -Members $samtxt.text
}

if ($grpbx365.isChecked){
Add-ADGroupMember -Identity "ADGroup 8" -Members $samtxt.text
}

Set-ADAccountPassword -Identity $samtxt.text -NewPassword (ConvertTo-SecureString -AsPlainText "$newPassword" -Force);

Enable-ADAccount -Identity $samtxt.text`

[System.Windows.Forms.MessageBox]::Show($dptxt.text + " has been created" + " and the password is " + $newPassword)

#clear Form
$fntxt.text =  ''
$lntxt.Text = ''
$emtxt.text = '' 
$mbtxt.text = ''
$samtxt.text = ''
$tltxt.text  = ''
$pwtxt.text = ''
$dptxt.Text = ''
$grpbxgen.isChecked = $false
$grpbxprod.isChecked = $false
$grpbxhs.isChecked = $false
$grpbxfac.isChecked = $false
$grpbxsm.isChecked = $false
$grpbxqc.isChecked = $false
$grpbxqa.isChecked = $false
$grpbxrd.isChecked = $false
$grpbxvpn.isChecked = $false
$grpbxla.isChecked = $false
$grpbx365.isChecked = $false
})




#Show Form
$Form.ShowDialog() | out-null

