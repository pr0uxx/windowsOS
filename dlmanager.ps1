####Download Manager####

#    This script is designed to be used for windows to manage downloaded items.
#      change \\MACHINE\disk\folder\subfolder on line 11 to your download location
#    
#    The first time you run this script, it will create a folder heirarchy for you to use
#      Once the folders have been created, set your download location to the Unsorted folder that the script has created. 

Set-ExecutionPolicy RemoteSigned # Set the exucution policy so Windows doesn't throw a tantrum

net use N: "\\MACHINE\disk\folder\subfolder" # Change me to your download location
$Logfile = "N:\dlmanager\Logs\$((Get-Date).ToString('dd-MM-yyyy'))$(gc env:computername).log" # This is where the logfiles will live and defines their naming convention


Function LogWrite
{
    Param ([string]$logstring)

    Add-Content $Logfile -Value $logstring
}

#check if the persistent file structure exists, if not create it. 
     if ((Test-Path N:\dlmanager\Logs) -eq 0) {
        
        New-Item -ItemType Directory -Path "N:\dlmanager\Logs";
        
        if ($LASTEXITCODE = 0) 
            {
            LogWrite "Cannot create folder as another folder already exists with the same name. Check if statement on Line 45";
            }
        else 
            {
            LogWrite "Folder successfully created!";
            }
    }
    else{
        LogWrite "Unsorted folder already exists";
    }
    
    if ((Test-Path N:\Unsorted) -eq 0) {
        
        LogWrite "Unsorted folder does not exist - creating new..."
        New-Item -ItemType Directory -Path "N:\Unsorted";
        
        if ($LASTEXITCODE = 0) 
            {
            LogWrite "Cannot create folder as another folder already exists with the same name. Check if statement on Line 27";
            }
        else 
            {
            LogWrite "Folder successfully created!";
            }
    }
    else{
        LogWrite "Unsorted folder already exists";
    }

   

if ((Test-Path N:\$((Get-Date).ToString('dd-MM-yyyy'))) -eq 0) ##check for the current day's folder
    
    {
    
    LogWrite "Folder does not exist, creating new...";
    New-Item -ItemType Directory -Path "N:\$((Get-Date).ToString('dd-MM-yyyy'))"; ##create a new current day folder if it doesn't already exist
    
    if ($LASTEXITCODE = 0) { ##If there was an error and the folder wasn't created, we'd like to know about it
        LogWrite "Cannot create folder as another folder already exists with the same name. Check if statement on Line 67"; # log the error
        }
    else { ## For instances where the folder has been successfully detected or it hasn't given 0 on lastexitcode
        LogWrite "Folder Exists, copying files...";
        Move-Item  N:\Unsorted\*\*.* N:\$((Get-Date).ToString('dd-MM-yyyy')); ##copy files
        
            if ($LASTEXITCODE = 0) { ##check for errors in the item move
            LogWrite "Moving files failed, not sure why"; ## this could be caused by a number of things not related to the program
             } 
            else {
            LogWrite "Items Moved Successfully!";
            }  
        }
    }
else ##if the folder existed all alone
    {
    Move-Item  N:\Unsorted\*\*.* N:\$((Get-Date).ToString('dd-MM-yyyy')); ##just move the items
        if ($LASTEXITCODE = 0) { ##check for errors in the item move
            LogWrite "Moving files failed, not sure why"; ## this could be caused by a number of things not related to the program
        } 
        else {
            LogWrite "Items Moved Successfully!";
        }
    }

LogWrite "Decluttering"
Remove-Item N:\$((Get-Date).ToString('dd-MM-yyyy'))\*.nfo;
Remove-Item N:\$((Get-Date).ToString('dd-MM-yyyy'))\*.txt;
Remove-Item -path N:\Unsorted\*

LogWrite "Script reached the end successfully"
LogWrite "!!--END OF LOG--!!"
