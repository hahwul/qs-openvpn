sudo apt-get update
sudo apt-get install openvpn
cd ~
wget -P ~/ https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.8/EasyRSA-3.0.8.tgz
tar xvf EasyRSA-3.0.8.tgz
cd ./EasyRSA-3.0.8/
cp vars.example vars
vim vars


./easyrsa init-pki
./easyrsa build-ca nopass
./easyrsa gen-req server nopass
sudo cp ./pki/private/server.key /etc/openvpn/
./easyrsa sign-req server server
sudo cp ./pki/issued/server.crt /etc/openvpn/
sudo cp ./pki/ca.crt /etc/openvpn/
./easyrsa gen-dh
openvpn --genkey --secret ta.key
sudo cp ./ta.key /etc/openvpn/
sudo cp ./pki/dh.pem /etc/openvpn/

mkdir -p ~/client-configs/keys
chmod -R 700 ~/client-configs

cd ~/EasyRSA-3.0.8/
./easyrsa gen-req abc nopass

sudo cp pki/private/abc.key ~/client-configs/keys/
./easyrsa sign-req client abc
sudo cp pki/issued/abc.crt ~/client-configs/keys/
sudo cp ~/EasyRSA-3.0.8/ta.key ~/client-configs/keys/
sudo cp /etc/openvpn/ca.crt ~/client-configs/keys/
sudo cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz  /etc/openvpn/
sudo gzip -d /etc/openvpn/server.conf.gz
sudo nano /etc/openvpn/server.conf
