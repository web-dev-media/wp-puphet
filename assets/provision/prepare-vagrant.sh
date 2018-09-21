#!/bin/bash

# Prepare Vagrantfile strip the hosts the Vagrant name and ip
# out of the composer.json and write the ip and name into the
# Vagrantfile. The host will written in to config/hosts.list
#
# Set symlinks from vendor/wp-content
# to vagrant/html/${host[1]}/${host[1]}/ for wp-content

# set colors
RED='\033[0;31m'
GREEN='\033[3;32;40m'
YELLOW='\033[1;33;40m'
NC='\033[0m' # No Color
symlinkFile="create-symlink.sh"
copie_str="${GREEN}Copy${NC}"
copie_sucees_str="${GREEN}Files copied${NC}\n\n"
error_str="${RED}Error:${NC}"

htmlBasePath='html/'

wp_config_dist='assets/data/wp-config.dist.php'

if [ -f "$wp_config_dist" ]; then
	cp $wp_config_dist ${htmlBasePath}/wp-config.php
	printf "  - ${copie_str} $wp_config_dist -> ${htmlBasePath}wp-config.php\n    ${copie_sucees_str}"
else
	printf "  - ${error_str} ${wp_config_dist} not found!\n";
fi


languages='assets/data/languages'
if [ -d "$languages" ]; then
	cp -r $languages ${htmlBasePath}wp-content/languages
	printf "  - ${copie_str} $languages -> ${htmlBasePath}wp-content/languages/\n    ${copie_sucees_str}"
else
	printf "  - ${error_str} ${languages} not found!\n";
fi


index='assets/data/index.dist.php'
if [ -f "$index" ]; then
	cp -r $index ${htmlBasePath}index.php
	printf "  - ${copie_str} $index -> ${htmlBasePath}index.php\n    ${copie_sucees_str}"
else
	printf "  - ${error_str} ${index} not found!\n";
fi


htaccess='assets/data/.htaccess.dist'
if [ -f "$htaccess" ]; then
	cp -r $htaccess ${htmlBasePath}.htaccess
	printf "  - ${copie_str} $htaccess -> ${htmlBasePath}.htaccess\n    ${copie_sucees_str}"
else
	printf "  - ${error_str} ${htaccess} not found!\n";
fi

sunrise='assets/data/sunrise.php'
if [ -f "$sunrise" ]; then
	cp -r $sunrise ${htmlBasePath}wp-content/sunrise.php
	printf "  - ${copie_str} $sunrise -> ${htmlBasePath}wp-content/sunrise.php\n    ${copie_sucees_str}"
else
	printf "  - ${error_str} ${sunrise} not found!\n";
fi


load_mu_plugins='assets/data/load-mu-plugins.php'
muplugin_path="${htmlBasePath}wp-content/mu-plugins"

if [ -f "$load_mu_plugins" ]; then
	if ! [ -d "$muplugin_path" ]; then
		mkdir $muplugin_path
	fi
	cp -r $load_mu_plugins ${muplugin_path}load-mu-plugins.php
	printf "  - ${copie_str} $load_mu_plugins -> ${muplugin_path}load-mu-plugins.php\n    ${copie_sucees_str}"
else
	printf "  - ${error_str} ${sunrise} not found!\n";
fi

puphpetPath="vendor/webdevmedia/puphpet"
vagrantFile="Vagrantfile"
dotVagrantFile=".vagrant"
customConfigSource="../config.yaml"
customConfigTarget="puphpet/config-custom.yaml"

if [ -d "$puphpetPath" ]; then
    
    if ! [ -f "puphpet" ]; then
        cp -r ${puphpetPath}/puphpet .
        printf "  - ${copie_str} ${puphpetPath}/puphpet  -> puphpet${NC}\n\n"
    else
	    printf "  - ${error_str} ${puphpetPath} not found!\n";
    fi
    
    if ! [ -f "$vagrantFile" ]; then
        cp ${puphpetPath}/${vagrantFile} .
        printf "  - ${copie_str} ${puphpetPath}/${vagrantFile}  -> ${vagrantFile}${NC}\n\n"
    fi

    if ! [ -f "$vagrantFile" ]; then
        cp ${puphpetPath}/${vagrantFile} .
        printf "  - ${copie_str} ${puphpetPath}/${vagrantFile}  -> ${vagrantFile}${NC}\n\n"
    fi

    if ! [ -f "$customConfigTarget" ]; then
        ln -s $customConfigSource $customConfigTarget
        printf "  - ${copie_str} $customConfigSource  -> $customConfigTarget${NC}\n\n"
    fi
    
else
    printf "  - ${error_str} ${vagrantFile} not found!\n";
fi

rm -rf ${htmlBasePath}wp/wp-content/
printf "  - ${RED}Delete${NC} WordPress default wp-content\n    ${GREEN}folder deleted${NC}\n\n"
