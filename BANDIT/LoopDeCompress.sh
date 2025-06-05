#!/bin/bash

filename="data"

while true
do
  type=$(file -b "$filename")

  echo "Current file type: $type"

  if [[ "$type" == *"ASCII text"* ]] || [[ "$type" == *"plain text"* ]]
  then
    echo "Reached plain text file! Contents:"
    cat "$filename"
    break
  elif [[ "$type" == *"gzip compressed data"* ]]
  then
    mv "$filename" "$filename.gz"
    gunzip "$filename.gz"
  elif [[ "$type" == *"bzip2 compressed data"* ]]
  then
    mv "$filename" "$filename.bz2"
    bunzip2 "$filename.bz2"
  elif [[ "$type" == *"Zip archive data"* ]]
  then
    mv "$filename" "$filename.zip"
    unzip "$filename.zip" -d temp_unzip_dir
    # Assuming unzip creates one file, move it back to filename
    mv temp_unzip_dir/* "$filename"
    rm -r temp_unzip_dir
  elif [[ "$type" == *"POSIX tar archive"* ]] || [[ "$type" == *"tar archive"* ]]
  then
    mkdir temp_tar_dir
    tar -xf "$filename" -C temp_tar_dir
    # Assuming single file extracted, move it to filename
    mv temp_tar_dir/* "$filename"
    rm -r temp_tar_dir
  else
    echo "Unknown file type or no more decompression possible."
    break
  fi
done
