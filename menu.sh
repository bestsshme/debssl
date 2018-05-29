#!/bin/bash
#Menu


echo -e "============ SELAMAT DATANG ==========="
echo -e ""
echo -e ""#!/bin/bash

MYIP=$(wget -qO- ipv4.icanhazip.com)

	clear

	echo "-- Selamat datang di Server - IP: $MYIP --"
	echo "----#============================#----"
	echo ""
	cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
	cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
	freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
	tram=$( free -m | awk 'NR==2 {print $2}' )
	swap=$( free -m | awk 'NR==4 {print $2}' )
	up=$(uptime|awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }')

	echo -e "\e[032;1mCPU model:\e[0m $cname"
	echo -e "\e[032;1mNumber of cores:\e[0m $cores"
	echo -e "\e[032;1mCPU frequency:\e[0m $freq MHz"
	echo -e "\e[032;1mTotal amount of ram:\e[0m $tram MB"
	echo -e "\e[032;1mTotal amount of swap:\e[0m $swap MB"
	echo -e "\e[032;1mSystem uptime:\e[0m $up"
	echo "------------------------------------------------------------------------------"
	echo "Apa yang ingin Anda lakukan?"
	echo -e "\e[031;1m 1\e[0m) Buat Akun SSH/OpenVPN"
	echo -e "\e[031;1m 2\e[0m) Ganti Password Akun SSH/OpenVPN"
	echo -e "\e[031;1m 3\e[0m) Perbarui Akun SSH/OpenVPN"
	echo -e "\e[031;1m 4\e[0m) Hapus Akun SSH/OpenVPN"
	echo -e "\e[031;1m 5\e[0m) Cek Login Dropbear, OpenSSH, SSL/TLS dan OpenVPN"
	echo -e "\e[031;1m 6\e[0m) Aktifkan Kill Multi Login"
	echo -e "\e[031;1m 7\e[0m) Daftar Akun dan Expire Date"
	echo -e "\e[031;1m 8\e[0m) Daftar Akun Aktif"
	echo -e "\e[031;1m 9\e[0m) Daftar Akun Expire"
	echo -e "\e[031;1m10\e[0m) Delete Akun Expire"
	echo -e "\e[031;1m11\e[0m) Restart Webmin"
	echo -e "\e[031;1m12\e[0m) Restart Dropbear"
	echo -e "\e[031;1m13\e[0m) Restart Openssh"
	echo -e "\e[031;1m14\e[0m) Restart Squid"
	echo -e "\e[031;1m15\e[0m) Ganti Port Squid"
	echo -e "\e[031;1m16\e[0m) Reboot Server"
	echo ""
	echo -e "\e[031;1m x\e[0m) Exit"
	echo ""
	read -p "Masukkan pilihan anda, kemudian tekan tombol ENTER: " option1
	case $option1 in
		1)
		clear
		usernew
		exit
		;;
		2)
		clear
		read -p "Ketik user yang akan di ganti passwordnya: " uname
		read -p "Silahkan isi passwordnya: " pass
		echo "$uname:$pass" | chpasswd
		echo "Mantap mbah...!!! Password $uname user berhasil sdi ganti...!!!"
		exit
		;;
		3)
		clear
		read -p "Enter username yg di perbarui: " uname
                read -p "Aktif sampai tanggal Thn-Bln-Hr(YYYY-MM-DD): " expdate
                renew_user
		exit
		;;
		4)
		clear
		hapus
		exit
		;;
		5)
		clear
		monssh2
		exit
		;;
		6)
		clear
		read -p "Isikan Maximal Login (1-2): " MULTILOGIN
		user-limit $MULTILOGIN
		exit
		;;
		7)
		clear
		not_expired_users
		exit
		;;
		8)
		clear
		expired_users
		exit
		;;
		9)
		clear
		user-expire-list
		exit
		;;
		10)
		clear
		delete-user-expire
	        echo "user kadaluarsa berhasil di  mbah...!!!"
		exit
		;;
		11)
		clear
		service webmin restart
	        echo "Webmin berhasil di restart mbah...!!!" 
		exit
		;;
		12)
		clear
		service dropbear restart
	        echo "Dropbear berhasil di restart mbah...!!!"
		exit
		;;
		13)
		clear
		service ssh restart
	        echo "OpenSSH berhasil di restart mbah...!!!" 
		exit
		;;
		14)
		clear
		service squid3 restart
	        echo "Squid sudah di restart mbah...!!!" 
		exit
		;;
		15)
		clear
		echo "Silahkan ganti port Squid3 anda lalu klik enter"
	        echo "Isi dengan angka tidak boleh huruf !!!"
	        read -p "Port Squid3: " -e -i 8080 PORT
                #sed -i 's/http_port [0-9]*\nhttp_port [0-9]*/http_port $PORT1\nhttp_port $PORT2/g' /etc/squid3/squid.conf
                sed -i "s/http_port [0-9]*/http_port $PORT/" /etc/squid3/squid.conf
	        service squid3 restart
                echo "Squid3 Updated Port: $PORT" 
		exit
		;;
		16)
		clear
		reboot
	        echo "Vps berhasil di reboot mbah...!!!" 
		exit
		x)
		clear
		exit
		;;
	esac
done
