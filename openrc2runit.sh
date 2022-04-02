#!/bin/bash

# https://www.coolgenerator.com/ascii-text-generator
# RUNIT TO OPENRC
echo ' __          __  __   __    __
/  \ _  _ _ |__)/      _)  |__)    _ .|_
\__/|_)(-| )| \ \__   /__  | \ |_|| )||_
    |                                    '

# Create files
touch openrc-list  openrc-list-1 runit-list-1

echo "Creating List of installed Runit pkgs"
pacman -Qsq openrc >> openrc-list

echo "Create List of required Openrc pkgs"
sed -e 's/openrc/runit/g' openrc-list >> runit-list

pacman -Sw $(cat runit-list) --noconfirm >> runit-list-1 2>&1
# Error check
if grep "error" runit-list-1;
    then
        echo "error"
        # Create list of unavailable pkgs
        sed -i -e 's/error: target not found://g' -e 's/ //g' runit-list-1
        # TODO remove unavailable pkgs
        comm -23 <(sort runit-list) <(sort runit-list-1) > runit-list-2
        echo "Downloading OpenRc pkgs"
        pacman -Sw $(cat runit-list-2)
        pacman -Rdd $(cat openrc-list)
        pacman -S $(cat runit-list-2)
        exit 1
else
    pacman -Rdd $(cat openrc-list)
    pacman -S $(cat runit-list)
fi
