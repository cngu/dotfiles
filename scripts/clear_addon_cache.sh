#!/bin/bash

echo
#ls ~/Library/Application\ Support/SMART\ Technologies/Notebook\ Software/Addon\ Cache/com.smarttech.lab
rm -rfv ~/Library/Application\ Support/SMART\ Technologies/Notebook\ Software/Addon\ Cache/com.smarttech.lab

echo
#ls ~/Library/Application\ Support/SMART\ Technologies/Notebook\ Software/Addons/LAB*.addon
rm -rfv ~/Library/Application\ Support/SMART\ Technologies/Notebook\ Software/Addons/LAB*.addon

echo
#ls /Applications/SMART\ Technologies/Notebook.app/Contents/Addons/LAB*.addon
sudo rm -fv /Applications/SMART\ Technologies/Notebook.app/Contents/Addons/LAB*.addon

echo
#ls /Applications/SMART\ Technologies/Notebook.app/Contents/SharedSupport/Addon\ Cache/com.smarttech.lab
sudo rm -rfv /Applications/SMART\ Technologies/Notebook.app/Contents/SharedSupport/Addon\ Cache/com.smarttech.lab
