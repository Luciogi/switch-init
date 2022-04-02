#!/bin/bash

# https://www.coolgenerator.com/ascii-text-generator
# RUNIT TO OPENRC
echo ' __             __    __          __  __
|__)    _ .|_    _)  /  \ _  _ _ |__)/
| \ |_|| )||_   /__  \__/|_)(-| )| \ \__
                         |               '

# Create files
touch openrc-list  openrc-list-1 runit-list-1

echo "Creating List of installed Runit pkgs"
pacman -Qsq runit > runit-list

echo "Create List of required Openrc pkgs"
sed -e 's/runit/openrc/g' -e '/rsm/d' -e '/openrc-rc/d' runit-list >> openrc-list

pacman -Sw $(cat openrc-list) --noconfirm >> openrc-list-1 2>&1

# Error check
if grep "error" openrc-list-1;
    then
        echo "error"
        # Create list of unavailable pkgs
        sed -i -e 's/error: target not found://g' -e 's/ //g' openrc-list-1
        # TODO remove unavailable pkgs
        comm -23 <(sort openrc-list) <(sort openrc-list-1) > openrc-list-2
        echo "Downloading OpenRc pkgs"
        pacman -Sw $(cat openrc-list-2)
        pacman -Rdd $(cat runit-list)
        pacman -S $(cat openrc-list-2)
        exit 1
else
    pacman -Rdd $(cat runit-list)
    pacman -S $(cat openrc-list)
fi
