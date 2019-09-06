#!/bin/bash

sudo apt-get install -y smartmontools > /dev/null

read -p "Enter Your name: " name
printf "<${name}'s Computer>\n" > device_info

printf "\n--------CPU Info--------\n\n" >> device_info
lscpu | grep -E "Model name|Core\(s\) per socket|Socket\(s\)" >> device_info

printf "\n--------GPU Info--------\n\n" >> device_info
sudo lshw -c display | grep -E "product" >> device_info

printf "\n--------RAM Info--------\n\n" >> device_info
sudo dmidecode --type memory |\
grep -E "Memory Device|Size:|Type:|Speed:" |\
grep -v "Clock Speed:" |\
grep -v "Error" >> device_info

printf "\n--------Disk Info--------\n\n" >> device_info

disk_device_array=( $(ls /dev/sd* | grep -v "[0-9]") )

for (( i=0; i<${#disk_device_array[@]}; i++ ))
do
    sudo smartctl -i ${disk_device_array[i]} |\
    grep -E "Model Family:|User Capacity:|Rotation Rate:|SATA Version is:"\
    >> device_info
    printf "\n"
done