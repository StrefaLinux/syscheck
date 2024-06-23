#!/bin/bash

# Collect data

# Get current user
current_user=$USER

# Get hostname
hostname=$(hostname)

# Get OS version
os_version=$(uname -a)

# Get distribution
distribution=$(lsb_release -d | cut -f2)

# Get architecture
architecture=$(uname -m)

# Get kernel version
kernel_version=$(uname -r)

# Get system uptime
uptime_info=$(uptime | awk '{print $3}' | cut -d "," -f1)

# Get detailed uptime
uptime_detailed=$(uptime)

# Check installed packages

# Get the shell version
shell_version=$BASH_VERSION

# Check screen resolution
screen_resolutions=$(xrandr | awk '/\*/ {print $1}' | tr '\n' ' ')

# Get the desktop environment
desktop_environment=$(sudo gnome-shell --version)

# Get the window manager
window_manager=$(wmctrl -m | awk '/Name:/ {print $2, $3}')

# Check the theme version
theme_dir="$HOME/.themes/your_theme_name"
metadata_file="$theme_dir/metadata.desktop"

# Get the terminal version
terminal_version=$(sudo gnome-terminal --version)

# Get CPU name
cpu_name=$(awk -F': ' '/model name/ {seen[$2]++} END {for (cpu in seen) print cpu " (" seen[cpu] ")" }' /proc/cpuinfo)


# Get GPU name
gpu_name=$(lspci | grep -i VGA | awk '{print $5, $8, $9, $10}')

# Check used and total RAM
total_ram=$(free -m | awk '/Mem:/ {print $2}')
used_ram=$(free -m | awk '/Mem:/ {print $3}')

# Set text colors
orange='\033[38;5;208m'
reset='\033[0m'

# Initialize the variable to store package counts
package_counts="${orange}Packages:${reset}"

# Function to append package count if greater than 0
append_package_count() {
    local count=$1
    local manager_name=$2
    if [ -n "$count" ] && [[ "$count" =~ ^[0-9]+$ ]] && [ $count -gt 0 ]; then
        package_counts+=" $count ($manager_name),"
    fi
}

# Check if dpkg is installed
if command -v dpkg &> /dev/null; then
    dpkg_count=$(dpkg -l | grep -c '^ii')
    append_package_count $dpkg_count "dpkg"
fi

# Check if snap is installed
if command -v snap &> /dev/null; then
    snap_count=$(snap list | wc -l)
    append_package_count $snap_count "snap"
fi

# Check if dnf is installed
if command -v dnf &> /dev/null; then
    dnf_count=$(dnf list installed | grep -c 'installed')
    append_package_count $dnf_count "dnf"
fi

# Check if yum is installed
if command -v yum &> /dev/null; then
    yum_count=$(yum list installed | grep -c 'installed')
    append_package_count $yum_count "yum"
fi

# Check if flatpak is installed
if command -v flatpak &> /dev/null; then
    flatpak_count=$(flatpak list | grep -v '^Ref' | wc -l)
    append_package_count $flatpak_count "flatpak"
fi

# Check if pacman is installed
if command -v pacman &> /dev/null; then
    pacman_count=$(pacman -Qq | wc -l)
    append_package_count $pacman_count "pacman"
fi

# Check if rpm is installed
if command -v rpm &> /dev/null; then
    rpm_count=$(rpm -qa | wc -l)
    append_package_count $rpm_count "rpm"
fi

# Remove the trailing comma
package_counts=${package_counts%,}

# ===============================

# Display data
toilet "SYSCHECK"
echo -e "..:: ${orange}$current_user${reset}@${orange}$hostname${reset} ::.."            # Display user and host
echo "---------------------------------"                                                 # Spacing line
echo -e "${orange}OS:${reset} $distribution $architecture"                               # Display distro name and architecture
echo -e "${orange}Kernel:${reset} $kernel_version"                                       # Display detalied kernel info
echo -e "${orange}Uptime:${reset} $uptime_info"                                          # Display session uptime
echo -e "$package_counts"                                                                # Display installed packages
echo -e "${orange}Shell:${reset} bash $shell_version"                                    # Display shell version
echo -e "${orange}Resolution:${reset} $screen_resolutions"                               # Display screen resolution
echo -e "${orange}Desktop Environment:${reset} $desktop_environment"                     # Display current DE
echo -e "${orange}Window Manager:${reset} $window_manager"                               # Display current WM
echo -e "${orange}Terminal:${reset} $terminal_version"                                   # Display current Terminal Version
echo -e "${orange}CPU:${reset} $cpu_name"                                                # Display CPU name
echo -e "${orange}GPU:${reset} $gpu_name"                                                # Display GPU name
echo -e "${orange}RAM:${reset} Used $used_ram MB of total $total_ram MB"                 # Display Memory info
echo "---------------------------------"                                                 # Spacing line
#echo -e "${orange}Detailed OS info:${reset} $os_version"                                # Display detailed OS information
#echo -e "${orange}Detailed uptime:${reset} $uptime_detailed"                            # Display detailed OS information
#echo "---------------------------------"                                                # Spacing line

