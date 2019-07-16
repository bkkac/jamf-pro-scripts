# JSS Scripts

The way you manage scripts depends on the way scripts are stored in your environment.There are two ways scripts can be stored:
-As data in the jamfsoftware database Before you can run a script in this type of environment, the script must exist in the database. 

There are two ways to achieve this:
- Add the script to Casper Admin Add the script to the JSS using the script editor. As files on your distribution point(s)—Before you can run a script in this type of environment, the script must exist on the distribution point you plan to deploy it from and in the JSS. 
- You can add the script to the master distribution point by adding it to Casper Admin. Then you can add the script to other distribution points via replication.

Each of these methods also involves configuring settings for the script. 
When you configure settings for a script, you can do the following:

- Add the script to a category. (For more information, see Categories.)
- Choose a priority for running the script during imaging.
- Enter parameter labels.
- Specify operating system requirements for running the script.
- When you add, edit, or delete a script in Casper Admin, the changes are reflected in the JSS and vice versa.

Requirements
To add a script to Casper Admin, the script file must be non-compiled and in one of the following formats:
- Perl (.pl)
- Bash (.sh)
- Shell (.sh)
- Non-compiled AppleScript (.applescript)
- C Shell (.csh)
- Zsh (.zsh)
- Korn Shell (.ksh)
- Tool Command Language (.tcl)
- Hypertext Preprocessor (.php)
- Ruby (.rb)
- Python (.py)

See the Wiki for how we are adding scripts to the JSS.