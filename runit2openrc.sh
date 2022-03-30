#!/bin/sh

echo "Switching Runit --> Openrc"
echo "Note: Make sure to stop Display Manager i.e sddm,gdm,lightdm"
echo "Creating List of installed init services"
pacman -Qsq runit > services.list
echo "Downloading Openrc & Openrc services"
pacman -Sw $(sed -e 's/runit/openrc/g' -e '/openrc-rc/d' -e '/rsm/d'< services.list)
echo "Removing Runit"
pacman -Rdd $(cat services.list)
echo "Installing Openrc & Openrc services"
pacman -S $(sed -e 's/runit/openrc/g' -e '/openrc-rc/d' -e '/rsm/d' < services.list)
