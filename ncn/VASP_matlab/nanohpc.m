clear;
clc;

% Main menu
main_choice = 0;
while(main_choice ~= 'q')
    
fprintf('##############################################################\n');
fprintf('##                                                          ##\n');
fprintf('##  NN   NN   AAA   NN   NN  OOOOO  HH   HH PPPPP   CCCCC   ##\n');
fprintf('##  NNN  NN AA   AA NNN  NN OO   OO HH   HH PP  PP CC   CC  ##\n');
fprintf('##  NNNN NN AA   AA NNNN NN OO   OO HH   HH PP  PP CC       ##\n');
fprintf('##  NN NNNN AA   AA NN NNNN OO   OO HHHHHHH PPPPP  CC       ##\n');
fprintf('##  NN  NNN AAAAAAA NN  NNN OO   OO HH   HH PP     CC   CC  ##\n');
fprintf('##  NN   NN AA   AA NN   NN  OOOOO  HH   HH PP      CCCCC   ##\n');
fprintf('##                                                          ##\n');
fprintf('##     MATLAB analytical solutions for VASP calculations    ##\n');
fprintf('##############################################################\n');
fprintf('\n');
fprintf(' Coding  : Dr.Kittiphong Amnuyswat\n');
fprintf(' Email   : kittiphong.am@kmitl.ac.th\n');
fprintf(' Version : 1.2.3 (10/12/2015)\n')
fprintf('---------------------------------------------------------\n');
fprintf('\n');

    fprintf('   --- MAIN MENU ---    \n')
    fprintf(' (0) : Time calculations\n');              % OK
    fprintf(' (1) : Convergence energy\n');             % OK
    fprintf(' (2) : Convergence KPOINTS\n');            % OK
    fprintf(' (3) : Lattice minimization\n');           % OK
    fprintf(' (4) : Band structure analysis\n');        % part
    fprintf(' (5) : DOS analysis\n');                   % part
    fprintf(' (6) : DFPT\n');                           % part
    fprintf(' (7) : Optical response\n');               % part
    fprintf(' (8) : CIF creation\n');                   % part
    fprintf(' (9) : Formation energy calculation\n');   % part
    fprintf(' (q) : Exit\n');
    fprintf('\n');
    main_choice = input(' Choice : ','s');
    switch(main_choice)
        case '0'
            VASP_timer;
        case '1'
            VASP_Conv_E;
        case '2'
            VASP_Conv_KP;
        case '3'
            VASP_Fitting_A;
        case '4'
            VASP_Band;
        case '5'
            VASP_DOS;
        case '6'
            VASP_DFPT;
        case '7'
            VASP_OPTIC; 
        case '8'
            VASP_CIF;
        case '9'
            fprintf('Unavaliable now !!!');
    end
end

diary off;
clear;