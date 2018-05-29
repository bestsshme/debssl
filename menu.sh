#!/bin/bash
#Menu


echo -e "============ SELAMAT DATANG ==========="
echo -e ""
echo -e ""#!/bin/bash

MYIP=$(wget -qO- ipv4.icanhazip.com)

	clear

	echo "-- Selamat datang di Server - IP: $MYIP --"
	echo "----#============================#----"
	echo "    # script by: Jucky vengeance #    "
	echo "    # Whatsapp : 083898587500    #    "
	echo "    # Facebook : Juckyvengeance  #    "
	echo "    #============================#    "
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
	echo -e "\e[031;1m 1\e[0m) Buat Akun SSH/OpenVPN (\e[34;1muser-add\e[0m)"
	echo -e "\e[031;1m 2\e[0m) Generate Akun SSH/OpenVPN (\e[34;1muser-gen\e[0m)"
	echo -e "\e[031;1m 3\e[0m) Ganti Password Akun SSH/OpenVPN (\e[34;1muser-pass\e[0m)"
	echo -e "\e[031;1m 4\e[0m) Tambah Masa Aktif Akun SSH/OpenVPN (\e[34;1muser-renew\e[0m)"
	echo -e "\e[031;1m 5\e[0m) Hapus Akun SSH/OpenVPN (\e[34;1muser-del\e[0m)"
	echo -e "\e[031;1m 6\e[0m) Buat Akun PPTP VPN (\e[34;1muser-add-pptp\e[0m)"
	echo -e "\e[031;1m 7\e[0m) Monitoring Dropbear (\e[34;1mdropmon [PORT]\e[0m)"
	echo -e "\e[031;1m 8\e[0m) Cek Login Dropbear, OpenSSH, PPTP VPN dan OpenVPN (\e[34;1muser-login\e[0m)"
	echo -e "\e[031;1m 9\e[0m) Kill Multi Login Manual (1-2 Login) (\e[34;1muser-limit [x]\e[0m)"
	echo -e "\e[031;1m10\e[0m) Daftar Akun dan Expire Date (\e[34;1muser-list\e[0m)"
	echo -e "\e[031;1m11\e[0m) Daftar Akun Aktif (\e[34;1muser-active-list\e[0m)"
	echo -e "\e[031;1m12\e[0m) Daftar Akun Expire (\e[34;1muser-expire-list\e[0m)"
	echo -e "\e[031;1m13\e[0m) Disable Akun Expire (\e[34;1mdisable-user-expire\e[0m)"
	echo -e "\e[031;1m14\e[0m) Delete Akun Expire (\e[34;1mdelete-user-expire\e[0m)"
	echo -e "\e[031;1m15\e[0m) Banned Akun (\e[34;1mbanned-user\e[0m)"
	echo -e "\e[031;1m16\e[0m) Restart Dropbear (\e[34;1re-drop\e[0m)"
	echo -e "\e[031;1m17\e[0m) Memory Usage (\e[34;1mps-mem\e[0m)"
	echo -e "\e[031;1m18\e[0m) Speedtest (\e[34;1mtest-speed\e[0m)"
	echo -e "\e[031;1m19\e[0m) Benchmark (\e[34;1mbenchmark\e[0m)"
	echo -e "\e[031;1m20\e[0m) Reboot Server (\e[34;1mreboot\e[0m)"
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
		user-gen
		exit
		;;
		3)
		clear
		user-pass
		exit
		;;
		4)
		clear
		user-renew
		exit
		;;
		5)
		clear
		hapus
		exit
		;;
		6)
		clear
		user-add-pptp
		exit
		;;
		7)
		clear
		read -p "Isikan Port Dropbear yang akan dimonitor: " PORT
		dropmon $PORT
		exit
		;;
		8)
		clear
		cek
		exit
		;;
		9)
		clear
		read -p "Isikan Maximal Login (1-2): " MULTILOGIN
		user-limit $MULTILOGIN
		exit
		;;
		10)
		clear
		member
		exit
		;;
		11)
		clear
		member
		exit
		;;
		12)
		clear
		user-expire-list
		exit
		;;
		13)
		clear
		disable-user-expire
		exit
		;;
		14)
		clear
		delete-user-expire
		exit
		;;
		15)
		clear
		banned-user
		exit
		;;
		16)
		clear
		service dropbear restart
		exit
		;;
		17)
		clear
		ps-mem
		exit
		;;
		18)
		clear
		speedtest
		exit
		;;
		19)
		clear
		benchmark
		exit
		;;
		20)
		clear
		reboot
		exit
		;;
		x)
		clear
		exit
		;;
	esac
done

cd ~/
rm -f /root/IP
echo -e "* menu      : menampilkan daftar perintah"
echo -e "* usernew   : membuat akun SSH & OpenVPN"
echo -e "* trial     : membuat akun trial"
echo -e "* hapus     : menghapus akun SSH & OpenVPN"
echo -e "* cek       : cek user login"
echo -e "* member    : daftar member SSH & OpenVPN"
echo -e "* resvis    : restart service dropbear, webmin"
echo -e "              squid3, OpenVPN dan SSH"
echo -e "* reboot    : reboot VPS"
echo -e "* speedtest : speedtest VPS"
echo -e "* info      : menampilkan informasi sistem"
echo -e "* about     : info script auto install"
echo -e "* exit      : keluar dari Putty/Connecbot/"
echo -e "              JuiceSSH"
echo -e ""
