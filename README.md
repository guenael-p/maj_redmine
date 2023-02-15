# maj_redmine
Simple script to update redmine 
tested from redmine-4.1.1 to redmine-4.2.5 & redmine-4.1.1 to redmine-5.0.4.
using 
- ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-linux-gnu]
- Rails 6.1.7
- Phusion Passenger 6.0.2
- Server version: Apache/2.4.29 (Ubuntu)
- Server built:   2023-01-31T14:01:53

you need to have your old install in /opt/, the script can be everywhere since he have right permission
you need to put your plugins in a folder called plugins in /home/redmine, but you can change it into the script

after this juste launch the script (./maj_redmine.sh);
  - put the old version number (4.1.1)
  - put the new (5.0.4)
wait

if it been working you can go on your navigator check if not here are the récurents error that i have corrected but still appeard sometimes
  - SECRET_KEY_BASE problems > sudo echo $SECRET_KEY_BASE ==> if there is nothing relunch the script and check it permission
  - plugins > if a plugins is not compatible... a lot of error will appeard so retry to lunch without the plugins folder
  - gems > check the logs errors and install missing gems
all problems will be repertoried into /var/log/apache2/error.log

if you need help with it i could be here to help
