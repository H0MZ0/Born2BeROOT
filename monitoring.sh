#!/bin/bash
monitoring() {
	CPUP=$(lscpu | grep '^CPU(s):' | awk '{print $2}')
	VCPU=$(lscpu | grep 'Thread(s) per core:' | awk '{print $4}')
	MEMU=$(free -m | grep "Mem" | awk '{print  $3 "/" $2 "MB" " ("$3/$2*100"%)"}')
	DESU="$(df -BG | awk '{print $3}' | grep G | tr -d 'G' | awk '{sum += $1} END {print sum}')" 
	DESU2=$(lsblk | awk 'NR==2 {print $4}')
       	DESU3=$(df -BG | awk '{print $5}' | grep % | tr -d '%' | awk '{sum += $1} END {print sum}')
	UCPU=$(echo "100 - $(mpstat 1 1 | grep 'all' | awk '{print $12}' | tail -n 1)" | bc)
	LBOOT=$(who -b | awk '{print $3" "$4}')
	LVMU=$(if lsblk | grep -q "lvm" ; then echo "yes"; else echo "no" ;fi)
	CTCP=$(ss -s | awk 'NR==2 {print $4}' | grep -o '[0-9]')
	ULOG=$(users | tr ' ' '\n' | wc -l)
	NIP1=$(ip a | grep "inet" | awk 'NR==3 {split($2, a, "/"); print a[1]}')
	NIP2=$(ip a | grep "link/ether" | awk '{print $2}')
	SUDO=$(sudo cat /var/log/sudo/sudo_config | grep "COMMAND" | wc -l)

	echo "#Architecture: $(uname -a)"
	echo "#CPU physical : $CPUP"
	echo "#vCPU : $VCPU"
	echo "#Memory Usage: $MEMU"
	echo "#Disk Usage: $DESU/$DESU2 ($DESU3%)"
	echo "#CPU load: ($UCPU%)"
	echo "#Last boot: $LBOOT"
	echo "#LVM use: $LVMU"
	echo "#Connections TCP : $CTCP ESTABLISHED"
	echo "#User log: $ULOG"
	echo "#Network: IP $NIP1 ($NIP2)"
	echo "#Sudo : $SUDO cmd"

}
monitoring | wall
