# variable pour la configuration
$URi = "http://192.168.0.56:3000"

# Extraction du blocage de compte le plus récent
# note : select -First 1 permet d'augementer significativement les performances en ne sélectionnant qu'une seule ligne
$lockedLog = Get-EventLog security | Where-Object instanceid -EQ 4740 | Select-Object -First 1
# Récupération de l'index de l'événement
$indexlog = $lockedLog.Index
# Récupération de la date et l'heure de l'événement
$timelog = $lockedLog.TimeGenerated
# Récupération du nom d'utilisateur et de la machine
$user = Get-Eventlog security | Where-Object index -EQ $indexlog | Select-Object -First 1| Select-Object -ExpandProperty ReplacementStrings | Select-Object -First 2
# Extraction du nom d'utilisateur
$username = $user.split(" ")[0]
# Extraction de l'ordinateur
$computer = $user.split(" ")[1]
# Recherche et récupération du nom complet de l'utilisateur
$findUser = Get-ADUser -filter "SamAccountName -like '$username'" | Select-Object name
$fullname = $findUser.name
# Génération du body de la requête POST
$postParams = @{username=$username;fullname=$fullname;time=$timelog;computer=$computer}
# Envoi de la commande
Invoke-WebRequest -Uri $URi -Method POST -Body $postParams
