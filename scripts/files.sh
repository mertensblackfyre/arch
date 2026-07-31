#!/bin/bash

# Backup destination
backup_path="/home/mertens/Documents/backups"  # Change this to your backup directory

# Individual source paths for each folder
declare -A folders
folders[moonr]="/home/mertens/Documents/moonreader"
folders[pview]="/home/mertens/Documents/PerfectViewer"
folders[fate]="/home/mertens/.var/app/com.usebottles.bottles/data/bottles/bottles/fate/drive_c/users/steamuser/AppData/Local/typemoon/fsn2/data/user/steam"

date=$(date +%Y-%m-%d)

# Backup each folder
for folder in "${!folders[@]}"; do
  source_folder="${folders[$folder]}"
  backup_subfolder="$backup_path/$folder"
  backup_folder="$backup_subfolder/${folder}-${date}"
  
  # Create subdirectory if it doesn't exist
  mkdir -p "$backup_subfolder"
  
  if [ -d "$source_folder" ]; then
    cp -r "$source_folder" "$backup_folder"
    echo "Backed up: $source_folder → $backup_folder"
  else
    echo "Warning: Folder '$source_folder' not found"
  fi
done

echo "Backup complete"
