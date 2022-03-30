#!/bin/sh

echo "Switching Openrc --> Runit"
echo "Note: Make sure to stop Display Manager i.e sddm,gdm,lightdm"
echo "Creating List of install init services"
pacman -Qsq openrc > services.list
echo "Downloading Openrc & Openrc services"
pacman -Sw $(sed -e 's/openrc/runit/g' < services.list)
echo "Removing Openrc"
pacman -Rdd $(cat services.list)
echo "Installing Runit & Runit services"
pacman -S $(sed -e 's/openrc/runit/g' < services.list)

