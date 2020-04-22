% Formation Energy Calculation

start_up;
fprintf('\n<<< Formation Energy Calculation form VASP OUTCAR >>>');
contact;

CPS = input('Compound name : ','s');
temp = input('Number of atom by formula : ','s');
natoms = str2double(temp);


% Read Bulk total energy --------------------
fprintf('\nBulk %s Calculation >>\n',CPS)
vasp_input;
read_etoten;
e_bulk = toten;
fprintf('>> Bulk %s Total energy               : %0.6f eV\n',CPS,e_bulk);

read_nions;
ntemp = nions/natoms;
e_bulk_pf = e_bulk/ntemp;
fprintf('>> Bulk %s Total energy (per formula) : %0.6f eV\n',CPS,e_bulk_pf);



% Read Bulk supercell total energy --------------------
fprintf('\nBulk supercell %s Calculation >>\n',CPS)
vasp_input;
read_etoten;
e_bulk_SC = toten;
fprintf('>> Bulk supercell %s Total energy               : %0.6f eV\n',CPS,e_bulk_SC);

read_nions;
ntemp = nions/natoms;
e_bulk_SC_pf = e_bulk_SC/ntemp;
fprintf('>> Bulk supercell %s Total energy (per formula) : %0.6f eV\n',CPS,e_bulk_SC_pf);



% Chemical Potential Calculation
% need fix for more than 2 atoms
temp = input('\nGrowth condition (element-rich) : ','s');
for k=1:natoms
    if k==1
        chm{k} = temp;
        vasp_input;
        read_nions;
        read_etoten;
        e_chm(k) = toten/nions;
    else
        chm{k}   = input('Element : ','s');
        e_chm(k) = e_bulk_SC_pf-e_chm(1);
    end
    fprintf('>> Bulk %s Total energy   : %0.6f eV\n\n',chm{k},e_chm(k));
end

VBM = 5.8216;
% col = hsv(10);
% col = prism(10);
col = [1.0, 0.0, 0.0  %red
       0.0, 0.0, 1.0  %blue
       0.0, 1.0, 0.0  %green
       1.0, 0.0, 1.0  %magenta
       0.0, 0.0, 0.0  %black
       0.819, 0.380, 0.0   %orange
       0.8, 0.027, 0.266   %pink
       0.0, 0.282, 0.612   %deep blue
       0.0, 0.192, 0.035   %deep green
       0.737, 0.137, 1.0   %purple
       0.224, 0.078, 0.023   %cocoa
       ];

cc  = 1;
nleg = 1;
oxy = 0;

% Native vacancy defect
complex=0;
defect='v';
VASP_Formation_Energy_cal_eform;

defect='i';
VASP_Formation_Energy_cal_eform;

defect='a';
VASP_Formation_Energy_cal_eform;


% Adding atom
chm{natoms+1}   = input('Element : ','s');
vasp_input;
read_nions;
read_etoten;
e_chm(natoms+1) = toten/nions;
fprintf('>> Bulk %s Total energy   : %0.6f eV\n\n',chm{natoms+1},e_chm(natoms+1));

oxy=1;
cc=1;
defect='oi';
VASP_Formation_Energy_cal_adding;

defect='oa';
VASP_Formation_Energy_cal_adding;


% Complex defect
VASP_Formation_Energy_cal_complex;

legend(leg2,'Location','northeastoutside');

finish;