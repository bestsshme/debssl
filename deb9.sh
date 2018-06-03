#!/bin/bash
#
# 
# Mod by jagoanssh.com
# ==================================================

# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";

#detail nama perusahaan
country=ID
state=JAGOANSSH.COM
locality=JAGOANSSH.COM
organization=JAGOANSSH.COM
organizationalunit=JAGOANSSH.COM
commonname=JAGOANSSH.COM
email=admin@jagoanssh.com

# go to root
cd

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# install wget and curl
apt-get update;apt-get -y install wget curl;

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart

# set repo
wget -O /etc/apt/sources.list "https://raw.githubusercontent.com/bestsshme/debssl/master/sources.list.debian7"
wget "http://www.dotdeb.org/dotdeb.gpg"
cat dotdeb.gpg | apt-key add -;rm dotdeb.gpg
sh -c 'echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list'
wget -qO - http://www.webmin.com/jcameron-key.asc | apt-key add -

# update
apt-get update

# install webserver
apt-get -y install nginx


# install essential package
apt-get -y install nano iptables dnsutils openvpn screen whois ngrep unzip unrar

echo "clear" >> .bashrc
echo 'echo -e "Selamat datang di server $HOSTNAME" | lolcat' >> .bashrc
echo 'echo -e "JAGOANSSH.COM"' >> .bashrc
echo 'echo -e "Ketik menu untuk menampilkan daftar perintah"' >> .bashrc
echo 'echo -e "---------------------------------------------------------------"' >> .bashrc

# install webserver
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/bestsshme/debssl/master/nginx.conf"
mkdir -p /home/vps/public_html
echo "<pre>WEBSITE JAGOANSSH.COM </pre>" > /home/vps/public_html/index.html
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/bestsshme/debssl/master/vps.conf"
service nginx restart

# install openvpn
wget -O /etc/openvpn/openvpn.tar "https://raw.githubusercontent.com/bestsshme/debssl/master/openvpn-debian.tar"
cd /etc/openvpn/
tar xf openvpn.tar
wget -O /etc/openvpn/1194.conf "https://raw.githubusercontent.com/bestsshme/debssl/master/1194.conf"
service openvpn restart
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
iptables -t nat -I POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE
iptables-save > /etc/iptables_yg_baru_dibikin.conf
wget -O /etc/network/if-up.d/iptables "hhttps://raw.githubusercontent.com/bestsshme/debssl/master/iptables"
chmod +x /etc/network/if-up.d/iptables
service openvpn restart

# konfigurasi openvpn
cd /etc/openvpn/
wget -O /etc/openvpn/client.ovpn "https://raw.githubusercontent.com/bestsshme/debssl/master/client-1194.conf"
sed -i $MYIP2 /etc/openvpn/client.ovpn;
cp client.ovpn /home/vps/public_html/

# install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "http://vira.cf/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/badvpn-udpgw "http://vira.cf/badvpn-udpgw64"
fi
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300

# setting port ssh
cd
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
service ssh restart

# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=3128/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 80 -p 777"/g' /etc/default/dropbear
sed -i 's/DROPBEAR_BANNER=""/DROPBEAR_BANNER="\/etc\/banner.net"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
cd /etc
wget https://raw.githubusercontent.com/bestsshme/debssl/master/banner.net
service ssh restart
service dropbear restart

# install squid3
cd
apt-get -y install squid3
wget -O /etc/squid3/squid.conf "https://raw.githubusercontent.com/bestsshme/debssl/master/squid3.conf"
sed -i $MYIP2 /etc/squid3/squid.conf;
service squid3 restart

# install fail2ban
apt-get -y install fail2ban;service fail2ban restart

# install webmin 1.820_all.deb


# install stunnel
apt-get install stunnel4 -y
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1


[dropbear]
accept = 443
connect = 127.0.0.1:3128

END

#membuat sertifikat
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

#konfigurasi stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/etc/init.d/stunnel4 restart

# teks berwarna
apt-get -y install ruby
gem install lolcat

# download script
cd /usr/bin
wget -O menu "https://raw.githubusercontent.com/bestsshme/debssl/master/menu.sh"
wget -O usernew "https://raw.githubusercontent.com/bestsshme/debssl/master/usernew.sh"
wget -O trial "https://raw.githubusercontent.com/bestsshme/debssl/master/trial.sh"
wget -O hapus "https://raw.githubusercontent.com/bestsshme/debssl/master/hapus.sh"
wget -O cek "https://raw.githubusercontent.com/bestsshme/debssl/master/user-login.sh"
wget -O member "https://raw.githubusercontent.com/bestsshme/debssl/master/user-list.sh"
wget -O resvis "https://raw.githubusercontent.com/bestsshme/debssl/master/resvis.sh"
wget -O speedtest "hhttps://raw.githubusercontent.com/bestsshme/debssl/master/speedtest_cli.py"
wget -O info "https://raw.githubusercontent.com/bestsshme/debssl/master/info.sh"
wget -O about "https://raw.githubusercontent.com/bestsshme/debssl/master/about.sh"

echo "1 2 * * * root /sbin/reboot" > /etc/cron.d/reboot

chmod +x menu
chmod +x usernew
chmod +x trial
chmod +x hapus
chmod +x cek
chmod +x member
chmod +x resvis
chmod +x speedtest
chmod +x info
chmod +x about

wget https://raw.githubusercontent.com/bestsshme/centos/master/banned-user && chmod +x banned-user
wget https://raw.githubusercontent.com/bestsshme/centos/master/delete-user-expire && chmod +x delete-user-expire
wget https://raw.githubusercontent.com/bestsshme/centos/master/user-expire-list && chmod +x user-expire-list
wget https://raw.githubusercontent.com/bestsshme/centos/master/user-list && chmod +x user-list
wget https://raw.githubusercontent.com/bestsshme/centos/master/user-renew && chmod +x user-renew
wget https://raw.githubusercontent.com/bestsshme/centos/master/users && chmod +x users
wget https://raw.githubusercontent.com/bestsshme/centos/master/user-active-list && chmod +x user-active-list
wget hhttps://raw.githubusercontent.com/bestsshme/centos/master/test.py && chmod +x test.py

# finishing
cd
chown -R www-data:www-data /home/vps/public_html
service nginx start
service openvpn restart
service cron restart
service ssh restart
service dropbear restart
service squid3 restart
service webmin restart
rm -rf ~/.bash_history && history -c
echo "unset HISTFILE" >> /etc/profile

# install neofetch
echo "deb http://dl.bintray.com/dawidd6/neofetch jessie main" | tee -a /etc/apt/sources.list
curl "https://bintray.com/user/downloadSubjectPublicKey?username=bintray"| apt-key add -
apt-get update
apt-get install neofetch

echo "deb http://dl.bintray.com/dawidd6/neofetch jessie main" | tee -a /etc/apt/sources.list
curl "https://bintray.com/user/downloadSubjectPublicKey?username=bintray"| apt-key add -
apt-get update
apt-get install neofetch

# info
clear
echo "Autoscript Include:" | tee log-install.txt
echo "===========================================" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Service"  | tee -a log-install.txt
echo "-------"  | tee -a log-install.txt
echo "OpenSSH  : 22, 444"  | tee -a log-install.txt
echo "Dropbear : 143, 777"  | tee -a log-install.txt
echo "SSL      : 443"  | tee -a log-install.txt
echo "Squid3   : 8000, 8080 (limit to IP SSH)"  | tee -a log-install.txt
echo "OpenVPN  : TCP 1194 (client config : http://$MYIP:81/client.ovpn)"  | tee -a log-install.txt
echo "badvpn   : badvpn-udpgw port 7300"  | tee -a log-install.txt
echo "nginx    : 81"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Script"  | tee -a log-install.txt
echo "------"  | tee -a log-install.txt
echo "menu (Menampilkan daftar perintah yang tersedia)"  | tee -a log-install.txt
echo "usernew (Membuat Akun SSH)"  | tee -a log-install.txt
echo "trial (Membuat Akun Trial)"  | tee -a log-install.txt
echo "hapus (Menghapus Akun SSH)"  | tee -a log-install.txt
echo "cek (Cek User Login)"  | tee -a log-install.txt
echo "member (Cek Member SSH)"  | tee -a log-install.txt
echo "resvis (Restart Service dropbear, webmin, squid3, openvpn dan ssh)"  | tee -a log-install.txt
echo "reboot (Reboot VPS)"  | tee -a log-install.txt
echo "speedtest (Speedtest VPS)"  | tee -a log-install.txt
echo "info (Menampilkan Informasi Sistem)"  | tee -a log-install.txt
echo "about (Informasi tentang script auto install)"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Fitur lain"  | tee -a log-install.txt
echo "----------"  | tee -a log-install.txt
echo "Webmin   : http://$MYIP:10000/"  | tee -a log-install.txt
echo "Timezone : Asia/Jakarta (GMT +7)"  | tee -a log-install.txt
echo "IPv6     : [off]"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Original Script by Jagoanssh.com"  | tee -a log-install.txt
echo "Modified by Jagoanssh.com"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Log Instalasi --> /root/log-install.txt"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "VPS AUTO REBOOT TIAP JAM 12 MALAM"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "==========================================="  | tee -a log-install.txt
cd
rm -f /root/mbakdeb.sh
