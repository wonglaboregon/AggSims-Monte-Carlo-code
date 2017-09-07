function Input=InputParams()
% Input parameters

% Path - This is where we can autosave resulting data. Not implemented yet.
Input.path='C:\Users\Cathy\Google Drive\Oregon\Research\Matlab\Self-Assembly\Results\2016\01\07';

% Grid creation variables
Input.x=20;
Input.y=20;
Input.z=20;
Input.coverage=0.05;

% Grid evolution variables
% Stabilization energy (in units of kT) when two adjacent sites have these elements:
% - s = solvent
% - b = substrate
% - m = molecule
Input.Ess=1; 
Input.Emm=[2 2 2; 2 2 2; 2 2 2];
Input.Ems=[3 3 3];
Input.Ecp=-1; % chemical potential of system, see Rabani paper
Input.Emb=[1 1 1];
Input.Esb=1;

%kB=8.617e-5; % eV/K
Input.kB=1.38e-23; % J/K
Input.Temp=298;
Input.kT=Input.kB*Input.Temp;
return;
