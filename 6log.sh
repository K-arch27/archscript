 cp -R ${SCRIPT_DIR} mnt/home/$USERNAME/Desktop/logs
    touch mnt/home/$USERNAME/Desktop/logs/IMPORTANT.txt
    echo "please delete this folder and the one inside /root/archscript, 
or move them to a secure location, 
since they contains trace of your installation (like your password and username) " > mnt/home/$USERNAME/Desktop/logs/IMPORTANT.txt
