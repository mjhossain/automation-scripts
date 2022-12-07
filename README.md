## Bash/Powershell Utility Scripts
This repo was created mainly to store helpful/utility **bash/powershell** scripts created throughtout semester for my **Automation** class.

### Bulk User Management (bulk-user-management.sh)
This script takes a csv file with Users: first name, last name,  and employee ID and creates linux users with a default password of 12345678 and the username format: first letter of firstname, full lastname and last 4-digits of employee id.

An example file of *roster_list.csv* can be found for testing.

**Please run this script in a test enviornment as it can delete important users if not used carefully.**

**TO-DOs**
- run `sudo -i` to get root terminal privileges.
- run `chmod +x bulk-user-management.sh` to give the script execute permission.