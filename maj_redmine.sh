
#!/bin/bash

# wich version needed
	echo "to which version redmine should be updated ? (exemple 5.0.4)"
		read new_version
		new_path=/opt/redmine-${new_version}
	echo "what is the latest version installed ? (exemple: 4.1.1)"
		read old_version
		old_path=/opt/redmine-${old_version}

# decompression
	cd /opt/
	sudo wget https://redmine.org/releases/redmine-${new_version}.zip
	sudo unzip /opt/redmine-${new_version}.zip
	sudo rm -r /opt/redmine-${new_version}.zip
	sudo chown -R redmine:redmine redmine-${new_version}
	sudo chmod -R 777 ${new_path}/log

#files copy
	cd ${new_path}
	sudo cp ${old_path}/config/database.yml config/
	sudo cp ${old_path}/config/configuration.yml config/
	sudo rm -r public/themes
	sudo cp -r ${old_path}/public/themes ${new_path}/public/themes
	sudo rsync -ah --progress  ${old_path}/files ${new_path}/

#plugins
	cd ${new_path}
	rm -r plugins/
	sudo cp -r /home/redmine/plugins ${new_path}/
	for i in `ls ${new_path}/plugins/`
	do
		cd ${new_path}/plugins/
		echo "unziping $i"
		sudo unzip $i
		echo "done"
	done
	sudo cp -r ${old_path}/vendor/ vendor/

#change the symlink
	cd /var/www
	sudo rm redmine
	sudo ln -s ${new_path}/public redmine

#install gems usefull
	cd ${new_path}
	sudo apt-get install libyaml-dev
	sudo gem install psych
	sudo gem uninstall -a psych
	sudo gem install rails -v 6.1.7
	sudo bundle install

# migrate data
	sudo bundle exec rake db:migrate RAILS_ENV=production
	sudo bundle exec rake redmine:plugins:migrate RAILS_ENV=production

	sudo chmod -R 777 ${new_path}/log

#key gestion
	sudo chmod 774 /etc/profile
	sudo chmod 774 /etc/environment

	cd ${new_path}

	tempo=$(sudo RAILS_ENV=production rake secret)

	ligne1=$(grep -n export /etc/profile | cut -d":" -f1);
	sudo sed -i "$ligne1 d" /etc/profile

	ligne2=$(grep -n export /etc/environment | cut -d":" -f1);
	sudo sed -i "$ligne2 d" /etc/environment

	ligne3=$(grep -n SECRET_KEY_BASE /etc/environment | cut -d":" -f1);
	sudo sed -i "$ligne3 d" /etc/environment

	sudo echo 'export SECRET_KEY_BASE='${tempo} >> /etc/environment && echo "ruby -e 'p" ' ["SECRET_KEY_BASE"]'"'" >> /etc/environment
	sudo echo 'export SECRET_KEY_BASE='${tempo} >> /etc/profile

#end
	sudo echo 'restarting'
	sudo reboot
