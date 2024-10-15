A series of scripts to dump partitions of android devices using dd

backup_interactive.sh does a backup asking the user what to backup and where, you can insert single partitions, or type all to backup everything.

dump_firmware.sh backups every partition on the system, you can edit the script to save the dumped partitions everywhere you want (it was the first version of this series).

restore_interactive.sh asks the user where is stored the backup folder, lists all the partitions inside that directory and asks if the user wants to restore them all or specific ones, if the user types yes it will restore everything, else the user can type the partitions he wants to restore and press enter. 
