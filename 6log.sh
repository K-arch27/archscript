SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source /root/archscript/config.sh


 cp -R ${SCRIPT_DIR} /home/$USERNAME/Desktop/logs
    touch /home/$USERNAME/Desktop/logs/IMPORTANT.txt
    echo "please delete this folder and the one inside /root/archscript, 
or move them to a secure location, 
since they contains trace of your installation (like your password and username) " > mnt/home/$USERNAME/Desktop/logs/IMPORTANT.txt
