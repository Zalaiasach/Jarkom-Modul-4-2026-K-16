# ==============================================================================
# BAGIAN 1: SELURUH ROUTER (13 ROUTER)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. ROUTER CYBERIA (NAT Gateway / Root Luar)
# ------------------------------------------------------------------------------
# eth0 -> NAT1 (GNS3)
# eth1 -> Switch1 (JJ & MyuMyu)
# eth2 -> Wired
cat << 'EOF' > /root/.bashrc
# Aktifkan interface
ip link set eth0 up
ip link set eth1 up
ip link set eth2 up

# IP Statis eth0 ke NAT1 GNS3 & Default Route ke Internet
ip addr add 192.168.122.100/24 dev eth0 2>/dev/null
ip route add default via 192.168.122.1 dev eth0 2>/dev/null

# IP Subnet Lokal (LAN Cyberia & P2P ke Wired)
ip addr add 192.219.24.1/25 dev eth1 2>/dev/null
ip addr add 192.219.24.130/30 dev eth2 2>/dev/null

# IP Forwarding & NAT Masquerade
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -F
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Rute balik Supernet /16 ke seluruh The Wired via Wired
ip route add 192.219.0.0/16 via 192.219.24.129 2>/dev/null
echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF
source /root/.bashrc


# ------------------------------------------------------------------------------
# 2. ROUTER WIRED (Pusat Agregasi CIDR / Hub Internal)
# ------------------------------------------------------------------------------
# eth0 -> Cyberia
# eth1 -> Switch2 (Hub Cabang Barat)
# eth2 -> Navi (Cabang Timur)
# eth3 -> Tachibana (Cabang Selatan)
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip link set eth1 up
ip link set eth2 up
ip link set eth3 up

ip addr add 192.219.24.129/30 dev eth0 2>/dev/null
ip addr add 192.219.10.73/29 dev eth1 2>/dev/null
ip addr add 192.219.18.65/30 dev eth2 2>/dev/null
ip addr add 192.219.23.41/30 dev eth3 2>/dev/null

echo 1 > /proc/sys/net/ipv4/ip_forward

# Default Route ke Cyberia / Internet
ip route add default via 192.219.24.130 2>/dev/null

# Rute Ringkasan CIDR Cabang Timur (Navi /22) & Selatan (Tachibana /22)
ip route add 192.219.16.0/22 via 192.219.18.66 2>/dev/null
ip route add 192.219.20.0/22 via 192.219.23.42 2>/dev/null

# Rute Cabang Barat (Switch2 Cluster)
ip route add 192.219.0.0/22 via 192.219.10.74 2>/dev/null
ip route add 192.219.4.0/22 via 192.219.10.76 2>/dev/null
ip route add 192.219.10.64/28 via 192.219.10.76 2>/dev/null
ip route add 192.219.8.0/23 via 192.219.10.75 2>/dev/null
ip route add 192.219.10.0/26 via 192.219.10.75 2>/dev/null
EOF
source /root/.bashrc


# ------------------------------------------------------------------------------
# 3. ROUTER PSYCHE
# ------------------------------------------------------------------------------
# eth0 -> Switch2
# eth1 -> Switch3 (Karl & Lin)
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip link set eth1 up

ip addr add 192.219.10.74/29 dev eth0 2>/dev/null
ip addr add 192.219.0.1/22 dev eth1 2>/dev/null

echo 1 > /proc/sys/net/ipv4/ip_forward
ip route add default via 192.219.10.73 2>/dev/null
EOF
source /root/.bashrc


# ------------------------------------------------------------------------------
# 4. ROUTER COPLAND
# ------------------------------------------------------------------------------
# eth0 -> Switch2
# eth1 -> Juri
# eth2 -> Switch4 (Masayuki)
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip link set eth1 up
ip link set eth2 up

ip addr add 192.219.10.75/29 dev eth0 2>/dev/null
ip addr add 192.219.10.1/26 dev eth1 2>/dev/null
ip addr add 192.219.8.1/23 dev eth2 2>/dev/null

echo 1 > /proc/sys/net/ipv4/ip_forward
ip route add default via 192.219.10.73 2>/dev/null
EOF
source /root/.bashrc


# ------------------------------------------------------------------------------
# 5. ROUTER SCHUMANN
# ------------------------------------------------------------------------------
# eth0 -> Switch2
# eth1 -> Akashic
# eth2 -> Accela
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip link set eth1 up
ip link set eth2 up

ip addr add 192.219.10.76/29 dev eth0 2>/dev/null
ip addr add 192.219.10.65/29 dev eth1 2>/dev/null
ip addr add 192.219.10.81/30 dev eth2 2>/dev/null

echo 1 > /proc/sys/net/ipv4/ip_forward
ip route add default via 192.219.10.73 2>/dev/null
ip route add 192.219.4.0/22 via 192.219.10.82 2>/dev/null
EOF
source /root/.bashrc


# ------------------------------------------------------------------------------
# 6. ROUTER ACCELA
# ------------------------------------------------------------------------------
# eth0 -> Schumann
# eth1 -> Switch5 (Omnipresence & Denpa)
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip link set eth1 up

ip addr add 192.219.10.82/30 dev eth0 2>/dev/null
ip addr add 192.219.4.1/22 dev eth1 2>/dev/null

echo 1 > /proc/sys/net/ipv4/ip_forward
ip route add default via 192.219.10.81 2>/dev/null
EOF
source /root/.bashrc


# ------------------------------------------------------------------------------
# 7. ROUTER NAVI
# ------------------------------------------------------------------------------
# eth0 -> Wired
# eth1 -> Switch6 (Alice & Reika)
# eth2 -> Switch7 (Taro)
# eth3 -> Switch8 (Yasuo, Miho, Kuma)
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip link set eth1 up
ip link set eth2 up
ip link set eth3 up

ip addr add 192.219.18.66/30 dev eth0 2>/dev/null
ip addr add 192.219.16.1/24 dev eth1 2>/dev/null
ip addr add 192.219.18.1/26 dev eth2 2>/dev/null
ip addr add 192.219.17.1/24 dev eth3 2>/dev/null

echo 1 > /proc/sys/net/ipv4/ip_forward
ip route add default via 192.219.18.65 2>/dev/null
EOF
source /root/.bashrc


# ------------------------------------------------------------------------------
# 8. ROUTER TACHIBANA
# ------------------------------------------------------------------------------
# eth0 -> Wired
# eth1 -> Switch9 (Collective & Ghost)
# eth2 -> Deus
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip link set eth1 up
ip link set eth2 up

ip addr add 192.219.23.42/30 dev eth0 2>/dev/null
ip addr add 192.219.20.1/23 dev eth1 2>/dev/null
ip addr add 192.219.23.45/30 dev eth2 2>/dev/null

echo 1 > /proc/sys/net/ipv4/ip_forward
ip route add default via 192.219.23.41 2>/dev/null
ip route add 192.219.22.0/24 via 192.219.23.46 2>/dev/null
ip route add 192.219.23.0/26 via 192.219.23.46 2>/dev/null
EOF
source /root/.bashrc


# ------------------------------------------------------------------------------
# 9. ROUTER DEUS
# ------------------------------------------------------------------------------
# eth0 -> Tachibana
# eth1 -> Switch10 (Lilith & Specter)
# eth2 -> Protocol7
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip link set eth1 up
ip link set eth2 up

ip addr add 192.219.23.46/30 dev eth0 2>/dev/null
ip addr add 192.219.22.1/25 dev eth1 2>/dev/null
ip addr add 192.219.23.49/30 dev eth2 2>/dev/null

echo 1 > /proc/sys/net/ipv4/ip_forward
ip route add default via 192.219.23.45 2>/dev/null
ip route add 192.219.22.128/25 via 192.219.23.50 2>/dev/null
ip route add 192.219.23.0/26 via 192.219.23.50 2>/dev/null
EOF
source /root/.bashrc


# ------------------------------------------------------------------------------
# 10. ROUTER PROTOCOL7
# ------------------------------------------------------------------------------
# eth0 -> Deus
# eth1 -> Switch11 (Chisa & Hodgeson)
# eth2 -> Knights
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip link set eth1 up
ip link set eth2 up

ip addr add 192.219.23.50/30 dev eth0 2>/dev/null
ip addr add 192.219.22.129/26 dev eth1 2>/dev/null
ip addr add 192.219.23.53/30 dev eth2 2>/dev/null

echo 1 > /proc/sys/net/ipv4/ip_forward
ip route add default via 192.219.23.49 2>/dev/null
ip route add 192.219.22.192/26 via 192.219.23.54 2>/dev/null
ip route add 192.219.23.0/26 via 192.219.23.54 2>/dev/null
EOF
source /root/.bashrc


# ------------------------------------------------------------------------------
# 11. ROUTER KNIGHTS
# ------------------------------------------------------------------------------
# eth0 -> Protocol7
# eth1 -> Eiri
# eth2 -> Phantoma
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip link set eth1 up
ip link set eth2 up

ip addr add 192.219.23.54/30 dev eth0 2>/dev/null
ip addr add 192.219.23.33/29 dev eth1 2>/dev/null
ip addr add 192.219.23.57/30 dev eth2 2>/dev/null

echo 1 > /proc/sys/net/ipv4/ip_forward
ip route add default via 192.219.23.53 2>/dev/null
ip route add 192.219.22.192/26 via 192.219.23.58 2>/dev/null
ip route add 192.219.23.0/27 via 192.219.23.58 2>/dev/null
EOF
source /root/.bashrc


# ------------------------------------------------------------------------------
# 12. ROUTER PHANTOMA
# ------------------------------------------------------------------------------
# eth0 -> Knights
# eth1 -> Switch12 (Semi)
# eth2 -> Shibuya
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip link set eth1 up
ip link set eth2 up

ip addr add 192.219.23.58/30 dev eth0 2>/dev/null
ip addr add 192.219.23.1/27 dev eth1 2>/dev/null
ip addr add 192.219.23.61/30 dev eth2 2>/dev/null

echo 1 > /proc/sys/net/ipv4/ip_forward
ip route add default via 192.219.23.57 2>/dev/null
ip route add 192.219.22.192/26 via 192.219.23.62 2>/dev/null
EOF
source /root/.bashrc


# ------------------------------------------------------------------------------
# 13. ROUTER SHIBUYA
# ------------------------------------------------------------------------------
# eth0 -> Phantoma
# eth1 -> Switch13 (Lain & Mika)
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip link set eth1 up

ip addr add 192.219.23.62/30 dev eth0 2>/dev/null
ip addr add 192.219.22.193/26 dev eth1 2>/dev/null

echo 1 > /proc/sys/net/ipv4/ip_forward
ip route add default via 192.219.23.61 2>/dev/null
EOF
source /root/.bashrc


# ==============================================================================
# BAGIAN 2: SELURUH HOST / CLIENT (25 HOST)
# ==============================================================================

# ----------------- CABANG BARAT -----------------
# Karl (Switch3)
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip addr add 192.219.0.2/22 dev eth0 2>/dev/null
ip route add default via 192.219.0.1 2>/dev/null
echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF
source /root/.bashrc

# Lin (Switch3)
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip addr add 192.219.0.3/22 dev eth0 2>/dev/null
ip route add default via 192.219.0.1 2>/dev/null
echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF
source /root/.bashrc

# Masayuki (Switch4)
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip addr add 192.219.8.2/23 dev eth0 2>/dev/null
ip route add default via 192.219.8.1 2>/dev/null
echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF
source /root/.bashrc

# Juri (Direct ke Copland)
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip addr add 192.219.10.2/26 dev eth0 2>/dev/null
ip route add default via 192.219.10.1 2>/dev/null
echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF
source /root/.bashrc

# Akashic (Direct ke Schumann)
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip addr add 192.219.10.66/29 dev eth0 2>/dev/null
ip route add default via 192.219.10.65 2>/dev/null
echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF
source /root/.bashrc

# Omnipresence (Switch5)
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip addr add 192.219.4.2/22 dev eth0 2>/dev/null
ip route add default via 192.219.4.1 2>/dev/null
echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF
source /root/.bashrc

# Denpa (Switch5)
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip addr add 192.219.4.3/22 dev eth0 2>/dev/null
ip route add default via 192.219.4.1 2>/dev/null
echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF
source /root/.bashrc


# ----------------- CABANG UTARA -----------------
# JJ (Switch1)
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip addr add 192.219.24.2/25 dev eth0 2>/dev/null
ip route add default via 192.219.24.1 2>/dev/null
echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF
source /root/.bashrc

# MyuMyu (Switch1)
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip addr add 192.219.24.3/25 dev eth0 2>/dev/null
ip route add default via 192.219.24.1 2>/dev/null
echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF
source /root/.bashrc


# ----------------- CABANG TIMUR -----------------
# Alice (Switch6)
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip addr add 192.219.16.2/24 dev eth0 2>/dev/null
ip route add default via 192.219.16.1 2>/dev/null
echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF
source /root/.bashrc

# Reika (Switch6)
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip addr add 192.219.16.3/24 dev eth0 2>/dev/null
ip route add default via 192.219.16.1 2>/dev/null
echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF
source /root/.bashrc

# Taro (Switch7)
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip addr add 192.219.18.2/26 dev eth0 2>/dev/null
ip route add default via 192.219.18.1 2>/dev/null
echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF
source /root/.bashrc

# Yasuo (Switch8)
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip addr add 192.219.17.2/24 dev eth0 2>/dev/null
ip route add default via 192.219.17.1 2>/dev/null
echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF
source /root/.bashrc

# Miho (Switch8)
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip addr add 192.219.17.3/24 dev eth0 2>/dev/null
ip route add default via 192.219.17.1 2>/dev/null
echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF
source /root/.bashrc

# Kuma (Switch8)
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip addr add 192.219.17.4/24 dev eth0 2>/dev/null
ip route add default via 192.219.17.1 2>/dev/null
echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF
source /root/.bashrc


# ----------------- CABANG SELATAN -----------------
# Collective (Switch9)
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip addr add 192.219.20.2/23 dev eth0 2>/dev/null
ip route add default via 192.219.20.1 2>/dev/null
echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF
source /root/.bashrc

# Ghost (Switch9)
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip addr add 192.219.20.3/23 dev eth0 2>/dev/null
ip route add default via 192.219.20.1 2>/dev/null
echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF
source /root/.bashrc

# Lilith (Switch10)
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip addr add 192.219.22.2/25 dev eth0 2>/dev/null
ip route add default via 192.219.22.1 2>/dev/null
echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF
source /root/.bashrc

# Specter (Switch10)
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip addr add 192.219.22.3/25 dev eth0 2>/dev/null
ip route add default via 192.219.22.1 2>/dev/null
echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF
source /root/.bashrc

# Chisa (Switch11)
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip addr add 192.219.22.130/26 dev eth0 2>/dev/null
ip route add default via 192.219.22.129 2>/dev/null
echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF
source /root/.bashrc

# Hodgeson (Switch11)
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip addr add 192.219.22.131/26 dev eth0 2>/dev/null
ip route add default via 192.219.22.129 2>/dev/null
echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF
source /root/.bashrc

# Eiri (Direct ke Knights)
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip addr add 192.219.23.34/29 dev eth0 2>/dev/null
ip route add default via 192.219.23.33 2>/dev/null
echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF
source /root/.bashrc

# Semi (Switch12)
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip addr add 192.219.23.2/27 dev eth0 2>/dev/null
ip route add default via 192.219.23.1 2>/dev/null
echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF
source /root/.bashrc

# Lain (Switch13)
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip addr add 192.219.22.194/26 dev eth0 2>/dev/null
ip route add default via 192.219.22.193 2>/dev/null
echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF
source /root/.bashrc

# Mika (Switch13)
cat << 'EOF' > /root/.bashrc
ip link set eth0 up
ip addr add 192.219.22.195/26 dev eth0 2>/dev/null
ip route add default via 192.219.22.193 2>/dev/null
echo "nameserver 8.8.8.8" > /etc/resolv.conf
EOF
source /root/.bashrc
