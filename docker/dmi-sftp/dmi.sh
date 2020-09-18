#!/usr/bin/expect

spawn sftp -vvv -i dmi.pem cardinalfinancial@secureftp.dmiconnect.com
expect "Enter passphrase for key 'dmi.pem':"
send $env(PASSPHRASE)\n
expect "cardinalfinancial@secureftp.dmiconnect.com's password:"
send $env(PASSWORD)\n
expect "sftp>"
send "ls\n"
send "exit\n"
interact