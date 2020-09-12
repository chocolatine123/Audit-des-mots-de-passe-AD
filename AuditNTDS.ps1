# Snapshot de l'AD
Write-Host "Snapshot de l'AD" -BackgroundColor Red
$date = Get-Date
$mois = $date.Month
$an = $date.Year
$jour = $date.Day
$AuditMDP = " AuditMDP."+$an+"."+$mois+"."+$jour+""
$folder = "C:\AuditMDP\"
cd $folder
ntdsutil snapshot "delete *" quit quit                                               #suppression des vieux snapshots           
Remove-Item -Path C:\$*
#Nouveau Snapshot
ntdsutil snapshot "activate instance ntds" create "list all" "mount 2" quit quit     

#Exportation des données systèmes
Write-Host "Exportation des données systèmes" -BackgroundColor Red
cd $folder
New-item -Path $folder -Name $AuditMDP -itemType directory
cd $AuditMDP
reg export HKLM\System system.reg
reg save HKLM\System system.hiv

#Déplacement des fichiers system.hiv et ntds.dit dans le repertoire ItAudit
cd $folder
Write-Host "Déplacement des fichiers" -BackgroundColor Red
Move-Item -Path C:\$*\Windows\NTDS\ntds.dit -Destination "$folder\$AuditMDP" 

# Installer ensuite impacket puis exécuter cette commande (sur Kali idéalement) pour extraire les hash :
python impacket/examples/secretsdump.py -ntds ntds.dit -system system.hiv LOCAL 
