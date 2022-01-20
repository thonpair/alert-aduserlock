# FR : variable pour la configuration
# EN : web server that listens to POST requests
$URi = "http://127.0.0.1:3000"

# FR : Extraction du blocage de compte le plus récent
# FR : note : Select-Object -First 1 permet d'augementer significativement les performances en ne sélectionnant qu'une seule ligne
# EN : Extraction of the most recent account block
# EN : note: Select-Object -First 1 allows to significantly increase performance by selecting only one line
$lockedLog = Get-EventLog security | Where-Object instanceid -EQ 4740 | Select-Object -First 1
# FR:  Récupération de l'index de l'événement
# EN : Get Event index
$indexlog = $lockedLog.Index
# FR : Récupération de la date et l'heure de l'événement
# EN : Get the event date and time
$timelog = $lockedLog.TimeGenerated
# FR : Récupération du nom d'utilisateur et de la machine
# EN : Extract username and computer name
$user = Get-Eventlog security | Where-Object index -EQ $indexlog | Select-Object -First 1| Select-Object -ExpandProperty ReplacementStrings | Select-Object -First 2
# FR : Extraction du nom d'utilisateur
# EN : Get username
$username = $user.split(" ")[0]
# FR : Extraction de l'ordinateur
# EN : get computer name
$computer = $user.split(" ")[1]
# FR : Recherche et récupération du nom complet de l'utilisateur
# EN : get user fullname
$findUser = Get-ADUser -filter "SamAccountName -like '$username'" | Select-Object name
$fullname = $findUser.name
# FR : Génération du body de la requête POST
# EN : Generate body of POST request
$postParams = @{username=$username;fullname=$fullname;time=$timelog;computer=$computer}
# FR : Envoi de la requête
# EN : send the request
Invoke-WebRequest -Uri $URi -Method POST -Body $postParams
