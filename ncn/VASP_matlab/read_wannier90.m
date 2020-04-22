% Read E-fermi value --------------------------
if ispc
    outcar = [vasp,'\wannier90.wout'];
else
    outcar = [vasp,'/wannier90.wout'];
end

LWANNIER90 = 'F';
if exist(outcar, 'file') == 2
    LWANNIER90 = 'T';
end

fprintf('\nWANNIER90                  LWANNIER90 = %s',LWANNIER90);

