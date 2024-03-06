#!/bin/bash

tw_address=$1
alias=$2

url="https://api.teamwork.su/q/address/$tw_address"
q_address=$(curl -sSL "$url")

mkdir /www.TeamWork.su && cd /www.TeamWork.su
package=qli-Client-1.8.5-Linux-x64.tar.gz
wget -4 -O $package https://dl.qubic.li/downloads/$package
tar -xzvf $package
mkdir /www.TeamWork.su/TeamWork.su_GPU
mkdir /www.TeamWork.su/TeamWork.su_CPU
cp /www.TeamWork.su/qli-Client /www.TeamWork.su/TeamWork.su_GPU/tw_gpu
cp /www.TeamWork.su/qli-Client /www.TeamWork.su/TeamWork.su_CPU/tw_cpu

echo "{\"Settings\": { \"allowHwInfoCollect\": true, \"overwrites\": {\"CUDA\": \"12\"}, \"baseUrl\": \"https://mine.qubic.li/\", \"payoutId\": \"$q_address\", \"alias\": \"${alias}_GPU\"}}" > /www.TeamWork.su/TeamWork.su_GPU/appsettings.json

cat >> /etc/supervisor/supervisord.conf <<\eof

[program:tw_gpu]
command=/www.TeamWork.su/TeamWork.su_GPU/tw_gpu
directory=/www.TeamWork.su/TeamWork.su_GPU
autostart=true
autorestart=true
eof

if [ -n "$3" ] && [ "$3" -gt 0 ]; then
echo "{\"Settings\": { \"amountOfThreads\": $3, \"allowHwInfoCollect\": true, \"baseUrl\": \"https://mine.qubic.li/\", \"payoutId\": \"$q_address\", \"alias\": \"${alias}_CPU\"}}" > /www.TeamWork.su/TeamWork.su_CPU/appsettings.json

cat >> /etc/supervisor/supervisord.conf <<\eof

[program:tw_cpu]
command=/www.TeamWork.su/TeamWork.su_CPU/tw_cpu
directory=/www.TeamWork.su/TeamWork.su_CPU
autostart=true
autorestart=true
eof
fi

supervisorctl reload