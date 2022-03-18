# alert-aduserlock

send a post request when an user is locked on Active Directory

## Task Schedule 

In Windows Task Sheduler, create a new Task with that configuration

* **General** tab : 
    * name : *task name*
    * use the following user account : Administrator
    * Run whether user is logged on or not
    * Run with highest privileges

* **Trigger** tab : 
    * Begin the task : On a event
    * Settings : Basic
    * Log: Security
    * Event ID: 4740
    * Enabled : checked

* **Actions** tab:
    * Action : Start a program
    * Program/script : C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
    * Add arguments : -noninteractive -Command " & *script fullpath*"
