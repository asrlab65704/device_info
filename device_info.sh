#!/bin/bash

sudo apt-get install -y smartmontools > /dev/null

read -p "Enter Your name: " name
output_file=device_info_${name// /_}.txt
printf "<${name}'s Computer>\n" > ${output_file}

printf "\n--------CPU Info--------\n\n" >> ${output_file}
lscpu | grep -E "Model name|Core\(s\) per socket|Socket\(s\)|每通訊端核心數：" >> ${output_file}

printf "\n--------GPU Info--------\n\n" >> ${output_file}
sudo lshw -c display | grep -E "product" >> ${output_file}

printf "\n--------RAM Info--------\n\n" >> ${output_file}
sudo dmidecode --type memory |\
grep -E "Memory Device|Size:|Type:|Speed:" |\
grep -v "Clock Speed:" |\
grep -v "Error" >> ${output_file}

printf "\n--------Disk Info--------\n\n" >> ${output_file}

disk_device_array=( $(ls /dev/sd* | grep -v "[0-9]") )

for (( i=0; i<${#disk_device_array[@]}; i++ ))
do
    sudo smartctl -i ${disk_device_array[i]} |\
    grep -E "Model Family:|User Capacity:|Rotation Rate:|SATA Version is:"\
    >> ${output_file}
    printf "\n"
done
printf "Finished. Please upload \"%s\"\n" ${output_file}
