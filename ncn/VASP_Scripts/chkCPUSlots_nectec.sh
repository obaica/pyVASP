#!/bin/bash
## Anupong Banjongkan

PBS_PROGRAM="/opt/torque/bin";
date; $PBS_PROGRAM/qstat -q;
echo -e "\n=============== $(hostname) ===============";
echo -e "<Hostname>: <CPUs>\t<Memory (M)>\t<Status>"
echo "========================================================="
# Collect the state of "sodium-x-y" compute nodes
for i in 0 1
do
	if [ $i == 0 ]
	then
		for j in {0..9}
		do
			$PBS_PROGRAM/pbsnodes sodium-$i-$j.ib | grep -e "state =" -e "jobs =" | awk 'BEGIN {RS="\n\n"; FS="\n"} {print $1,$2}'> /tmp/tmp1.txt;
			$PBS_PROGRAM/pbsnodes sodium-$i-$j.ib | grep "state =" | awk '{print $3}' > /tmp/tmp2.txt;
			$PBS_PROGRAM/pbsnodes sodium-$i-$j.ib | grep "np =" | awk '{print $3}' > /tmp/tmp3.txt;
			ssh sodium-$i-$j.ib free -m | grep Mem | awk '{print $3,$2}' > /tmp/tmp4.txt;
			file=/tmp/tmp1.txt;
			exec 3<&0
			exec 0<$file
			while read line
			do
        			echo $line > /tmp/tmp1.txt;
				echo -e "sodium-$i-$j: $(tr -cs 'A-Za-z' '\n' < /tmp/tmp1.txt | grep -c "hydrogen")/$(cat /tmp/tmp3.txt)\t$(awk '{print $1}' < /tmp/tmp4.txt)/$(awk '{print $2}' < /tmp/tmp4.txt)\t($(cat /tmp/tmp2.txt))";
			done
			exec 0<&3
		done
	else
		for j in {0..1}
		do
			$PBS_PROGRAM/pbsnodes sodium-$i-$j.ib | grep -e "state =" -e "jobs =" | awk 'BEGIN {RS="\n\n"; FS="\n"} {print $1,$2}' > /tmp/tmp1.txt;
			$PBS_PROGRAM/pbsnodes sodium-$i-$j.ib | grep "state =" | awk '{print $3}' > /tmp/tmp2.txt;
			$PBS_PROGRAM/pbsnodes sodium-$i-$j.ib | grep "np =" | awk '{print $3}' > /tmp/tmp3.txt;
			ssh sodium-$i-$j.ib free -m | grep Mem | awk '{print $3,$2}' > /tmp/tmp4.txt;
                        file=/tmp/tmp1.txt;
                        exec 3<&0
                        exec 0<$file
                        while read line
                        do
                                echo $line > /tmp/tmp1.txt;
                                echo -e "sodium-$i-$j: $(tr -cs 'A-Za-z' '\n' < /tmp/tmp1.txt | grep -c "hydrogen")/$(cat /tmp/tmp3.txt)\t$(awk '{print $1}' < /tmp/tmp4.txt)/$(awk '{print $2}' < /tmp/tmp4.txt)\t($(cat /tmp/tmp2.txt))";
                        done    
                        exec 0<&3
		done
	fi	
done

# Collect the state of "radium-0-y" compute nodes
for i in {0..2}
do
	$PBS_PROGRAM/pbsnodes radium-0-$i.ib | grep -e "state =" -e "jobs =" | awk 'BEGIN {RS="\n\n"; FS="\n"} {print $1,$2}'> /tmp/tmp1.txt;
	$PBS_PROGRAM/pbsnodes radium-0-$i.ib | grep "state =" | awk '{print $3}' > /tmp/tmp2.txt;
	$PBS_PROGRAM/pbsnodes radium-0-$i.ib | grep "np =" | awk '{print $3}' > /tmp/tmp3.txt;
	ssh radium-0-$i.ib free -m | grep Mem | awk '{print $3,$2}' > /tmp/tmp4.txt;
	file=/tmp/tmp1.txt;
	exec 3<&0
	exec 0<$file
	while read line
	do
		echo $line > /tmp/tmp1.txt;
		echo -e "radium-0-$i: $(tr -cs 'A-Za-z' '\n' < /tmp/tmp1.txt | grep -c "hydrogen")/$(cat /tmp/tmp3.txt)\t$(awk '{print $1}' < /tmp/tmp4.txt)/$(awk '{print $2}' < /tmp/tmp4.txt)\t($(cat /tmp/tmp2.txt))";
	done
	exec 0<&3
done

# Collect the state of "osmium-0-y" compute nodes
for i in {0..7}
do
	$PBS_PROGRAM/pbsnodes osmium-0-$i.ib | grep -e "state =" -e "jobs =" | awk 'BEGIN {RS="\n\n"; FS="\n"} {print $1,$2}'> /tmp/tmp1.txt;
	$PBS_PROGRAM/pbsnodes osmium-0-$i.ib | grep "state =" | awk '{print $3}' > /tmp/tmp2.txt;
	$PBS_PROGRAM/pbsnodes osmium-0-$i.ib | grep "np =" | awk '{print $3}' > /tmp/tmp3.txt;
	ssh osmium-0-$i.ib free -m | grep Mem | awk '{print $3,$2}' > /tmp/tmp4.txt;
	file=/tmp/tmp1.txt;
	exec 3<&0
	exec 0<$file
	while read line
	do
		echo $line > /tmp/tmp1.txt;
		echo -e "osmium-0-$i: $(tr -cs 'A-Za-z' '\n' < /tmp/tmp1.txt | grep -c "hydrogen")/$(cat /tmp/tmp3.txt)\t$(awk '{print $1}' < /tmp/tmp4.txt)/$(awk '{print $2}' < /tmp/tmp4.txt)\t($(cat /tmp/tmp2.txt))";                 
	done
	exec 0<&3
done

# Collect the state of "nobelium-0-0" compute nodes
$PBS_PROGRAM/pbsnodes nobelium-0-0.ib | grep -e "state =" -e "jobs =" | awk 'BEGIN {RS="\n\n"; FS="\n"} {print $1,$2}'> /tmp/tmp1.txt;
$PBS_PROGRAM/pbsnodes nobelium-0-0.ib | grep "state =" | awk '{print $3}' > /tmp/tmp2.txt;
$PBS_PROGRAM/pbsnodes nobelium-0-0.ib | grep "np =" | awk '{print $3}' > /tmp/tmp3.txt;
ssh nobelium-0-0.ib free -m | grep Mem | awk '{print $3,$2}' > /tmp/tmp4.txt;
file=/tmp/tmp1.txt;
exec 3<&0
exec 0<$file
while read line
do
	echo $line > /tmp/tmp1.txt;
	echo -e "nobelium-0-0: $(tr -cs 'A-Za-z' '\n' < /tmp/tmp1.txt | grep -c "hydrogen")/$(cat /tmp/tmp3.txt)\t$(awk '{print $1}' < /tmp/tmp4.txt)/$(awk '{print $2}' < /tmp/tmp4.txt)\t($(cat /tmp/tmp2.txt))";                 
done
exec 0<&3

# Collect the state of "gadolinium-0-0" compute nodes
$PBS_PROGRAM/pbsnodes gadolinium-0-0.ib | grep -e "state =" -e "jobs =" | awk 'BEGIN {RS="\n\n"; FS="\n"} {print $1,$2}'> /tmp/tmp1.txt;
$PBS_PROGRAM/pbsnodes gadolinium-0-0.ib | grep "state =" | awk '{print $3}' > /tmp/tmp2.txt;
$PBS_PROGRAM/pbsnodes gadolinium-0-0.ib | grep "np =" | awk '{print $3}' > /tmp/tmp3.txt;
ssh gadolinium-0-0.ib free -m | grep Mem | awk '{print $3,$2}' > /tmp/tmp4.txt;
file=/tmp/tmp1.txt;
exec 3<&0
exec 0<$file
while read line
do
        echo $line > /tmp/tmp1.txt;
        echo -e "gadolinium-0-0: $(tr -cs 'A-Za-z' '\n' < /tmp/tmp1.txt | grep -c "hydrogen")/$(cat /tmp/tmp3.txt)\t$(awk '{print $1}' < /tmp/tmp4.txt)/$(awk '{print $2}' < /tmp/tmp4.txt)\t($(cat /tmp/tmp2.txt))";
done
exec 0<&3

echo "=========================================================";
rm -rf /tmp/tmp*.txt;
