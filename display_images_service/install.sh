#!/bin/bash
# Check if the password argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0  <sudo_password>"
    exit 1
fi

# Assign the first argument to PW
PW=$1

# Set the port
PORT=58607

SERVICE_FOLDER="server"

LG_SCREEN_AMOUNT=$(grep -oP '(?<=DHCP_LG_FRAMES_MAX=).*' /home/lg/personavars.txt)

time=$(date +%H:%M:%S)
echo "[$time] Installing Display Images Service for LG Space Visualizations..."

# Open port
LINE=`cat /etc/iptables.conf | grep "tcp" | grep "8111" | awk -F " -j" '{print $1}'`
RESULT=$LINE",$PORT"

DATA=`cat /etc/iptables.conf | grep "tcp" | grep "8111" | grep "$PORT"`

if [ "$DATA" == "" ]; then
  time=$(date +%H:%M:%S)
  echo "[$time] Opening port $PORT..."
  echo $PW | sudo -S sed -i "s/$LINE/$RESULT/g" /etc/iptables.conf
else
  time=$(date +%H:%M:%S)
  echo "[$time] Port $PORT is already open."
fi

# Install dependencies
time=$(date +%H:%M:%S)
echo "[$time] Installing dependencies..."
chmod +x scripts/open.sh scripts/close.sh
cd $SERVICE_FOLDER/
echo $PW | sudo -S npm install -y

# Add access for pm2
echo $PW | sudo -S chown lg:lg /home/lg/.pm2/rpc.sock /home/lg/.pm2/pub.sock

# Stop server if already started
echo $PW | sudo -S pm2 delete Display_Images_Service_LG_Space_Visualizations:$PORT 2> /dev/null

# Start server
time=$(date +%H:%M:%S)
echo "[$time] Starting pm2..."
echo $PW | sudo -S pm2 start server.js --name Display_Images_Service_LG_Space_Visualizations:$PORT
echo $PW | sudo -S pm2 save

# Add automatic pm2 resurrect script
time=$(date +%H:%M:%S)
echo "[$time] Updating resurrect script..."
RESURRECT=$(pm2 startup | grep 'sudo')
echo $PW | sudo -S sh -c '$RESURRECT'

time=$(date +%H:%M:%S)
echo "[$time] Installation complete. Please reboot your machine to finish the process."

echo $PW | sudo -S reboot