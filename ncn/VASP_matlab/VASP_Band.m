fprintf('---------------------------------------------------------\n');
fprintf(' (4) : Band structure analysis\n');

fprintf('\n');
vasp_input;
tic;

% -----------------------------------------------------
% MATLAB log file
if ispc
    log = [vasp,'\MATLAB_Band.log'];
else
    log = [vasp,'/MATLAB_Band.log'];
end
diary(log);
diary on;
% -----------------------------------------------------


% -----------------------------------------------------
% Check HSE calculation
read_hse;
read_SOC;
read_ispin;
read_nbands;
read_nvb;
read_wannier90;

% if (hse=='T'&&ispin==1)
%    VASP_Band_HSE;
    
% elseif (hse=='T'&&ispin==2)
%    VASP_Band_HSE;
    
if (hse=='F')
   VASP_Band_LDA;
%   VASP_Band_HSE;

% if LWANNIER90 == 'T'
%    VASP_Band_wannier90;
else
    VASP_Band_HSE;
end
% -----------------------------------------------------


clear vasp;

fprintf('\nTime Usage : %0.4f sec.\n',toc);
fprintf('---------------------------------------------------------\n');
fprintf('\n');
diary off;
