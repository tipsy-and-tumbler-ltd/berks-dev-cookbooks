#!/bin/bash

# Find location of this script.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Add the development cookbooks
tar -cf cookbooks.tar \
	--exclude=.git \
	cookbooks

# Move the tarball to our next working dir
mv cookbooks.tar ~/.berkshelf/

# Go to the berkshelf and add the rest
cd ~/.berkshelf
tar -rf cookbooks.tar \
	--exclude=chef-php-extra-master \
	--exclude=chef-dsdev-database-master \
	--exclude=chef-dynamic-vhost-master \
	cookbooks

# Move our tarball back
mv cookbooks.tar "$DIR/"

# Gzip it
cd "$DIR"
gzip cookbooks.tar
