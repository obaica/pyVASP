### Declare job non-rerunable
#PBS -r n
### Output files
#PBS -e parallel.err
#PBS -o parallel.log
### Mail to user
#PBS -m ae
### Queue name (small, medium, long, verylong)
###PBS -q long
### Number of nodes (node property ev67 wanted)
#PBS -l walltime=500:00:00
#PBS -l nodes=1:ppn=8
#################################################
####### Change to your name #####################
#################################################

#yourname=kaswat

#################################################
# This job's working directory
echo Working directory is $PBS_O_WORKDIR
cd $PBS_O_WORKDIR    

echo Running on host `hostname`
echo Time is `date`
echo Directory is `pwd`
echo This jobs runs on the following processors:
echo `cat $PBS_NODEFILE`
cat $PBS_NODEFILE > $PBS_O_WORKDIR/NODERUN

# Define number of processors
NPROCS=`wc -l < $PBS_NODEFILE`
echo This job has allocated $NPROCS nodes


#sort $PBS_O_WORKDIR/NODERUN |uniq > $PBS_O_WORKDIR/Machine 

#machines=$(sort $PBS_O_WORKDIR/NODERUN |uniq)
#echo $machines>$PBS_O_WORKDIR/Machine2
cp $PBS_O_WORKDIR/* ${TMPDIR}
cd ${TMPDIR}

. /state/partition4/copt/Modules/default/init/bash
#module load lammpi
#module load vasp.mpi/4.6.31
#module load vasp/5.2.2 pgi/7.0.2 lammpi/7.1.4
module load vasp/5.2.11 ifort lammpi/7.1.4-ifort
lamboot $PBS_NODEFILE
#################################################
for k in  1.55 1.56 1.57 1.58 1.59 1.60 1.61 1.62 1.63 1.64 1.65
do
echo " InN-WZ-4atoms c/a=$k" > POSCAR-$k
echo "   3.51187" >> POSCAR-$k
echo "0.50000  -0.866025  0.00000">>POSCAR-$k
echo "0.50000   0.866025  0.00000">>POSCAR-$k
echo "0.00000   0.000000  $k">>POSCAR-$k
tail +6 CONTCAR>>POSCAR-$k
cp POSCAR-$k POSCAR

mpirun -O -c2c -np $NPROCS vasp.mpi

E=`tail -1 OSZICAR`
echo "$k  $E" >> SUMMARY-v
mv OSZICAR OSZICAR-$k
cp CONTCAR CONTCAR-$k
mv OUTCAR OUTCAR-$k
done
cat SUMMARY-v |awk '{print $1"  "$6}' >> data-v

###############################################
lamhalt
cp ${TMPDIR}/* $PBS_O_WORKDIR
