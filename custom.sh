#!/bin/bash

cd ${GITHUB_WORKSPACE}/openwrt/files || exit 0

# ===================== 网络配置 =====================
mkdir -p etc/config
cat > etc/config/network <<EOF
config interface 'loopback'
    option ifname 'lo'
    option proto 'static'
    option ipaddr '127.0.0.1'
    option netmask '255.0.0.0'

config interface 'lan'
    option ifname 'eth0'
    option proto 'static'
    option ipaddr '192.168.1.1'
    option netmask '255.255.255.0'
    option ip6assign '60'

config interface 'wan'
    option ifname 'eth1'
    option proto 'dhcp'

config interface 'wan6'
    option ifname 'eth1'
    option proto 'dhcpv6'
EOF

# ===================== 密码 shadow =====================
cat > etc/shadow <<EOF
root:$1$WnUqCk5R$CvC8R.pJH5tT9qkO7xN5d/:0:0:99999:7:::
daemon:*:0:0:99999:7:::
ftp:*:0:0:99999:7:::
nobody:*:0:0:99999:7:::
EOF

# ===================== 强制型号显示为 XG-140G-MD =====================
mkdir -p etc/board.d/
cat > etc/board.d/01_override_model <<'EOF'
#!/bin/sh
echo "airoha,an7581-nokia-xg-140g-md" > /tmp/sysinfo/board_name
echo "Nokia XG-140G-MD" > /tmp/sysinfo/model
EOF
chmod +x etc/board.d/01_override_model

# ===================== 权限 =====================
chmod 644 etc/config/network
chmod 600 etc/shadow
