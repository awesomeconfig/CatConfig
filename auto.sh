#full system update and installing packages kernel
sudo pacman -R linux linux-headers
sudo pacman -R nvidia-dkms nvidia-settings nvidia-utils
sudo pacman -S linux-xanmod linux-xanmod-headers
sudo pacman -Syu
#sudo pacman -S nvidia-dkms nvidia-settings nvidia-utils
sudo pacman -S mesa-utils
sudo pacman -R vim vim-runtime
sudo pacman -S xfce4
sudo pacman -R arcolinuxd-welcome-app-git archlinux-wallpaper arcolinux-alacritty-git arcolinux-sddm-simplicity-git
###### Config Optimizetions ####
#!/bin/bash

# Function to create or overwrite a file with the provided content
create_or_overwrite_file() {
  local file="$1"
  local content="$2"
  
  echo "$content" > "$file"
  echo "Created or updated $file."
}

# Configure /etc/sysctl.conf
sysctl_content="
net.core.rmem_default=262144
net.core.rmem_max=16777216
net.core.wmem_default=262144
net.core.wmem_max=16777216
net.ipv4.tcp_tw_reuse=1
fs.file-max=65536
net.ipv4.tcp_window_scaling=1
net.ipv4.tcp_timestamps=1
net.ipv4.tcp_sack=1
net.ipv4.tcp_fastopen=3
net.ipv4.ip_local_port_range=1024 65535
net.ipv4.tcp_max_syn_backlog=4096
net.ipv4.tcp_congestion_control=cubic
net.ipv4.tcp_max_orphans=16384
net.ipv6.conf.all.disable_ipv6=1
net.ipv6.conf.default.disable_ipv6=1
vm.vfs_cache_pressure=50
vm.dirty_ratio=10
vm.dirty_background_ratio=5
vm.overcommit_memory=1
vm.overcommit_ratio=80
vm.dirty_expire_centisecs=3000
vm.dirty_writeback_centisecs=1500
kernel.numa_balancing=1
kernel.shmmax=536870912
kernel.shmall=2097152
fs.nr_open=1000000"

create_or_overwrite_file "/etc/sysctl.conf" "$sysctl_content"

# Configure /etc/mkinitcpio.conf
mkinitcpio_content="# vim:set ft=sh
# MODULES
MODULES=\"crc32c-intel zswap zram\"

# BINARIES
BINARIES=(setfont)

# HOOKS
HOOKS=\"base udev autodetect modconf block filesystems\"

# COMPRESSION
COMPRESSION=\"lzop\"

# MODULES_DECOMPRESS
MODULES_DECOMPRESS=\"yes\""

create_or_overwrite_file "/etc/mkinitcpio.conf" "$mkinitcpio_content"

# Configure /etc/default/grub
grub_content="GRUB_DEFAULT=0
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR='ArcoLinux'
GRUB_CMDLINE_LINUX_DEFAULT='quiet i915.modeset=1 loglevel=3 audit=0 nvme_load=yes intel_pstate=performance i915.enable_dc=0 i915.enable_fbc=1 i915.semaphores=1 zswap.enabled=1'
GRUB_CMDLINE_LINUX=\"quiet\"

GRUB_PRELOAD_MODULES=\"part_gpt part_msdos\"
GRUB_TIMEOUT_STYLE=menu
GRUB_TERMINAL_INPUT=console
GRUB_THEME=\"/boot/grub/themes/Vimix/theme.txt\"
GRUB_DISABLE_RECOVERY=true
GRUB_DISABLE_OS_PROBER=false

GRUB_CMDLINE_LINUX_DEFAULT+=\" intel_idle.max_cstate=0 processor.max_cstate=1\"
GRUB_CMDLINE_LINUX_DEFAULT+=\" mem_sleep_default=deep\"
GRUB_CMDLINE_LINUX_DEFAULT+=\" nvidia-drm.modeset=1\"
GRUB_CMDLINE_LINUX_DEFAULT+=\" pci=nocrs\"
GRUB_CMDLINE_LINUX_DEFAULT+=\" i915.fastboot=1\"
GRUB_CMDLINE_LINUX_DEFAULT+=\" pcie_aspm=force\"
################### optimiztaions ########################\"\"
GRUB_SAVEDEFAULT=\"true\"
GRUB_DISABLE_SUBMENU=y

# Section 1: Memory Optimizations
GRUB_CMDLINE_LINUX_DEFAULT=\"zswap.enabled=1 zswap.compressor=z3fold maxcpus=4 clocksource=tsc hpet=force\"

# Section 2: CPU Optimizations
GRUB_CMDLINE_LINUX_DEFAULT+=\" intel_pstate=disable acpi_cpufreq.performance=1 intel_idle.max_cstate=0 processor.max_cstate=1 mem_sleep_default=deep nohz_full=1 rcu_nocbs=0-7\"

# Section 3: NV Graphics Optimizations
GRUB_CMDLINE_LINUX_DEFAULT+=\" nvidia-drm.modeset=1 nvidia-drm.pstate=0 i915.fastboot=1\"

# Section 4: Additional I/O Optimization
GRUB_CMDLINE_LINUX_DEFAULT+=\" elevator=mq-deadline io_poll=1\"

# Section 5: Disable Unused Controllers
GRUB_CMDLINE_LINUX_DEFAULT+=\" pci=nocrs pci=nomsi pci=noaer\"
### Section 6 : Other 
# Uncomment the following line to enable 'multi-queue block I/O queueing mechanism'
 GRUB_CMDLINE_LINUX_DEFAULT+=\" io_poll=1\"
 # Uncomment to enable the 'nohz_full' feature for lower CPU latency
GRUB_CMDLINE_LINUX_DEFAULT+=\" nohz_full=1\"

# Uncomment to enable the 'RCU_NOCB' feature for lower CPU latency
GRUB_CMDLINE_LINUX_DEFAULT+=\" rcu_nocbs=0-7\"
# Uncomment to enable Early Microcode Loading for Intel CPUs
GRUB_CMDLINE_LINUX_DEFAULT+=\" early_ucode=1\"

# Uncomment to enable High-Resolution Timer (HRT) for better timekeeping
 GRUB_CMDLINE_LINUX_DEFAULT+=\" clocksource=tsc hpet=force\""

create_or_overwrite_file "/etc/default/grub" "$grub_content"

echo "Config Optimizetions conmplete"
echo "Customizetions config"
#!/bin/bash

# Update Alacritty configuration
cat <<EOF > ~/.config/alacritty/alacritty.yml
shell:
  program: /bin/fish

colors:
  primary:
    background: "#303446"
    foreground: "#C6D0F5"
    dim_foreground: "#C6D0F5"
    bright_foreground: "#C6D0F5"

  cursor:
    text: "#303446"
    cursor: "#F2D5CF"
  vi_mode_cursor:
    text: "#303446"
    cursor: "#BABBF1"

  search:
    matches:
      foreground: "#303446"
      background: "#A5ADCE"
    focused_match:
      foreground: "#303446"
      background: "#A6D189"
    footer_bar:
      foreground: "#303446"
      background: "#A5ADCE"

  hints:
    start:
      foreground: "#303446"
      background: "#E5C890"
    end:
      foreground: "#303446"
      background: "#A5ADCE"

  selection:
    text: "#303446"
    background: "#F2D5CF"

  normal:
    black: "#51576D"
    red: "#E78284"
    green: "#A6D189"
    yellow: "#E5C890"
    blue: "#8CAAEE"
    magenta: "#F4B8E4"
    cyan: "#81C8BE"
    white: "#B5BFE2"

  bright:
    black: "#626880"
    red: "#E78284"
    green: "#A6D189"
    yellow: "#E5C890"
    blue: "#8CAAEE"
    magenta: "#F4B8E4"
    cyan: "#81C8BE"
    white: "#A5ADCE"

  dim:
    black: "#51576D"
    red: "#E78284"
    green: "#A6D189"
    yellow: "#E5C890"
    blue: "#8CAAEE"
    magenta: "#F4B8E4"
    cyan: "#81C8BE"
    white: "#B5BFE2"

  indexed_colors:
    - { index: 16, color: "#EF9F76" }
    - { index: 17, color: "#F2D5CF" }
EOF

# Update Neofetch configuration
cat <<EOF > ~/.config/neofetch/config.conf
# Neofetch Config
# More info: https://github.com/dylanaraps/neofetch/wiki/Config-File

# Info
info title
info underline

info "\e[31m " distro
info "\e[33m " $(cat /proc/1/comm)
info "\e[32m󰏗 " packages
info "\e[34m " wm
info "\e[35m " term
info cols

# Uptime
uptime_shorthand="on"

# Memory
memory_percent="off"
memory_unit="mib"

# Packages
package_managers="off"

# Shell
shell_path="off"
shell_version="on"

# CPU
speed_type="bios_limit"
speed_shorthand="on"
cpu_brand="off"
cpu_speed="on"
cpu_cores="off"
cpu_temp="off"

# GPU
gpu_brand="on"
gpu_type="all"

# Resolution
refresh_rate="off"

# Gtk Theme / Icons / Font
gtk_shorthand="on"
gtk2="on"
gtk3="on"

# IP Address
public_ip_host="http://ident.me"
public_ip_timeout=2

# Desktop Environment
de_version="on"

# Disk
disk_show=('/')
disk_subtitle="mount"
disk_percent="on"

# Song
music_player="cmus"
song_format="%artist% - %album% - %title%"
song_shorthand="on"
mpc_args=()

# Text Colors
colors=(distro)

# Text Options
bold="on"
underline_enabled="on"
underline_char="─"
separator=" "

# Color Blocks
block_range=(0 7)
color_blocks="on"
block_width=3
block_height=1
col_offset="auto"

# Progress Bars
bar_char_elapsed="-"
bar_char_total="="
bar_border="on"
bar_length=15
bar_color_elapsed="distro"
bar_color_total="distro"

# Info display
cpu_display="off"
memory_display="off"
swap_display="off"
gpu_display="off"
EOF

echo "Configuration updated successfully!"


