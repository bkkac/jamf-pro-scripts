#!/bin/bash
## Set a variable that takes the output of the current console owner and cut the result down
user=`ls -l /dev/console | cut -d " " -f 4`
osxmajor=$(sw_vers -productVersion | awk -F. '{print $1}')
osxminor=$(sw_vers -productVersion | awk -F. '{print $2}')

## Start Apache
apachectl start

##Add $user, root, and macroot to _developer group
dscl . -append /Groups/_developer GroupMembership $user
dscl . -append /Groups/_developer GroupMembership root
dscl . -append /Groups/_developer GroupMembership macroot

##Make Homebrew caches folder if it doesn't exist and set perms
mkdir -p /Library/Caches/Homebrew
chown -R root:_developer /Library/Caches/Homebrew
chmod -R ug+rwx /Library/Caches/Homebrew

##Make Sites folder if it doesn't exist and set perms
mkdir -p /Users/$user/Sites
chown $user:"COLLEMCVOY.com\Domain Users" /Users/$user/Sites
chmod -R u+rw /Users/$user/Sites
chmod -R g+r /Users/$user/Sites

##Set permissions for existing directories
chown -R :_developer /usr/local
chmod -R g=u /usr/local
chown -R :_developer /usr/bin
chmod -R g=u /usr/bin
chown -R :_developer /Library/Ruby
chmod -R g=u /Library/Ruby
chown -R :_developer /Library/Python
chmod -R g=u /Library/Python

##Set permissions for existing files
chown :_developer /private/etc/hosts
chmod g=u /private/etc/hosts
chown :_developer /private/etc/php.ini
chmod g=u /private/etc/php.ini
chown :_developer /private/etc/pear.config
chmod g=u /private/etc/pear.config

if [ $osxminor == "8" ] || [ $osxminor == "9" ]
then
  echo "OS matched 10.8 or 10.9, should match next line"
  echo "$osxmajor.$osxminor"
  ##rewrite httpd-vhosts.conf file to allow for sharing of sites

  if grep "Allow from 10" /private/etc/apache2/extra/httpd-vhosts.conf >/dev/null 2>&1 ; then
      echo "VHosts file already exists with appropriate beginning, NOT overwriting"
  else
cat > /private/etc/apache2/extra/httpd-vhosts.conf <<- EOF
#
# Virtual Hosts
#
# If you want to maintain multiple domains/hostnames on your
# machine you can setup VirtualHost containers for them. Most configurations
# use only name-based virtual hosts so the server doesn't need to worry about
# IP addresses. This is indicated by the asterisks in the directives below.
#
# Please see the documentation at
# <URL:http://httpd.apache.org/docs/2.2/vhosts/>
# for further details before you try to setup virtual hosts.
#
# You may use the command line option '-S' to verify your virtual host
# configuration.

#
# Use name-based virtual hosting.
#
NameVirtualHost *:80

#
# VirtualHost example:
# Almost any Apache directive may go into a VirtualHost container.
# The first VirtualHost section is used for all requests that do not
# match a ServerName or ServerAlias in any <VirtualHost> block.
#
#<VirtualHost *:80>
#    ServerAdmin webmaster@dummy-host.example.com
#    DocumentRoot "/usr/docs/dummy-host.example.com"
#    ServerName dummy-host.example.com
#    ServerAlias www.dummy-host.example.com
#    ErrorLog "/private/var/log/apache2/dummy-host.example.com-error_log"
#    CustomLog "/private/var/log/apache2/dummy-host.example.com-access_log" common
#</VirtualHost>


<Directory /Users/$user/Sites/>
  Options Indexes +FollowSymLinks
  AllowOverride All
  Order deny,allow
  Deny from all
  Allow from 10.
  Allow from 127.
  Allow from localhost
</Directory>

<VirtualHost *:80>
  ServerAdmin webmaster@dummy-host.example.com
  DocumentRoot "/Users/$user/Sites/"
  ServerName local
  ServerAlias localhost
  ErrorLog "/Users/Shared/local.err.log"
  CustomLog "/Users/Shared/local.log" common
</VirtualHost>
EOF
  fi
elif [ $osxminor == "10" ]
then
  echo "OS matched 10.10, should match next line"
  echo "$osxmajor.$osxminor"

  ##rewrite httpd-vhosts.conf file to allow for sharing of sites

  if grep "Require ip 10." /private/etc/apache2/extra/httpd-vhosts.conf >/dev/null 2>&1 ; then
      echo "VHosts file already exists with appropriate beginning, NOT overwriting"
  else
cat > /private/etc/apache2/extra/httpd-vhosts.conf <<- EOF
#
# Virtual Hosts
#
# If you want to maintain multiple domains/hostnames on your
# machine you can setup VirtualHost containers for them. Most configurations
# use only name-based virtual hosts so the server doesn't need to worry about
# IP addresses. This is indicated by the asterisks in the directives below.
#
# Please see the documentation at
# <URL:http://httpd.apache.org/docs/2.2/vhosts/>
# for further details before you try to setup virtual hosts.
#
# You may use the command line option '-S' to verify your virtual host
# configuration.

#
# Use name-based virtual hosting.
#
NameVirtualHost *:80

#
# VirtualHost example:
# Almost any Apache directive may go into a VirtualHost container.
# The first VirtualHost section is used for all requests that do not
# match a ServerName or ServerAlias in any <VirtualHost> block.
#
#<VirtualHost *:80>
#    ServerAdmin webmaster@dummy-host.example.com
#    DocumentRoot "/usr/docs/dummy-host.example.com"
#    ServerName dummy-host.example.com
#    ServerAlias www.dummy-host.example.com
#    ErrorLog "/private/var/log/apache2/dummy-host.example.com-error_log"
#    CustomLog "/private/var/log/apache2/dummy-host.example.com-access_log" common
#</VirtualHost>

<Directory /Users/$user/Sites/>
  Options Indexes FollowSymLinks
  AllowOverride All
<RequireAny>
  Require ip 10. 127.0.0.1
  Require host localhost local
</RequireAny>
</Directory>

<VirtualHost *:80>
  ServerAdmin webmaster@dummy-host.example.com
  DocumentRoot "/Users/$user/Sites/"
  ServerName local
  ServerAlias localhost
  ErrorLog "/Users/Shared/local.err.log"
  CustomLog "/Users/Shared/local.log" common
</VirtualHost>
EOF
  fi
else
  osx=`sw_vers -productVersion`
  echo "OSX version is not supported for rewriting vhosts file, current version shows:"
  echo "$osxmajor.$osxminor"
fi

##Make backup of httpd.conf and then edit to make sure httpd.conf is not commenting out httpd-vhosts.conf file plus set perms on httpd.conf
mv /etc/apache2/httpd.conf /etc/apache2/httpd.conf.bak
cat /etc/apache2/httpd.conf.bak | sed 's/#Include\ \/private\/etc\/apache2\/extra\/httpd-vhosts.conf/Include\ \/private\/etc\/apache2\/extra\/httpd-vhosts.conf/g'  > /etc/apache2/httpd.conf.temp
cat /etc/apache2/httpd.conf.temp | sed 's/#LoadModule\ php5_module\ libexec\/apache2\/libphp5.so/LoadModule\ php5_module\ libexec\/apache2\/libphp5.so/g'  > /etc/apache2/httpd.conf
rm /etc/apache2/httpd.conf.temp
#LoadModule\ php5_module\ libexec\/apache2\/libphp5.so
chown -R :_developer /private/etc/apache2/httpd.conf
chmod -R g=u /private/etc/apache2/httpd.conf

## Set dev perms to all httpd files in EXTRA folder
chown -R :_developer /private/etc/apache2/extra
chmod -R g=u /private/etc/apache2/extra

## Reload apache to kick in
apachectl restart
