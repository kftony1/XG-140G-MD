#!/bin/bash
# Nokia XG-040G-MD 自定义配置脚本

# 进入固件根文件系统目录
cd $GITHUB_WORKSPACE/openwrt/files || exit 0

# ==============================================
# 1. 写入网络配置文件 /etc/config/network
# ==============================================
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

# ==============================================
# 2. 写入系统密码 /etc/shadow
# ==============================================
cat > etc/shadow <<EOF
root:$1$WnUqCk5R$CvC8R.pJH5tT9qkO7xN5d/:0:0:99999:7:::
daemon:*:0:0:99999:7:::
ftp:*:0:0:99999:7:::
nobody:*:0:0:99999:7:::
EOF

# ==============================================
# 3. 启用达发 2.5G PHY / 复旦微闪存 / USB 驱动
# ==============================================
sed -i 's/# CONFIG_PACKAGE_kmod-usb3 is not set/CONFIG_PACKAGE_kmod-usb3=y/' ../.config
sed -i 's/# CONFIG_PACKAGE_kmod-usb2 is not set/CONFIG_PACKAGE_kmod-usb2=y/' ../.config
sed -i 's/# CONFIG_PACKAGE_kmod-phy-realtek is not set/CONFIG_PACKAGE_kmod-phy-realtek=y/' ../.config

# 权限修复
chmod 644 etc/config/network
chmod 600 etc/shadow
