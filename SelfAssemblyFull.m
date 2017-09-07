% Input:
% - Tfinal = The number of time steps
%
% Output:
% - FullGrid = Array with info about the system at each timepoint
%               - Input = Input parameters for this timestep
%               - Solvent = Location grid, 1 = solvent, 0 = no solvent
%               - Molecules = Location grid with molecule indices
%               - ListM = List of molecules by index
%               - ListA = List of aggregates by index
%               - NMolecules = number of molecules
% - Log = Log of changes to the system during each timestep

function [FullGrid,Log]=SelfAssemblyFull(Tfinal)
tic;
% Load input parameters
Input=InputParams();
% Create the initial grid at T=1
[Grids,Log]=CreateGrids2(Input);
% Assign this first grid to FullGrid array
[Grids]=TabNMers(Grids);
FullGrid(1)=Grids;

% Loop over each subsequent timestep
for T=2:Tfinal
    Log{end+1,1}=['T' num2str(T)];
    % Evolve the grid
    [FullGrid(T),Log]=EvolveGrid(FullGrid(T-1),FullGrid(T-1).Input,Log,[0 1 1 1 1]);
	% Some function that will input the grid and output a structure that has a table that is 3 x n where 3 corresponds to
	% the three types of aggregates (RGB), and n is each of the n-mers. The entries of this structure will be the number of
	% each of the types of n-mers there are at each time step. example: [NMers(T)]=TabNMers(FullGrid(T)), where NMers(1)
	% will have the 3 x n matrix of aggregates for that time step.
	[FullGrid(T)]=TabNMers(FullGrid(T));
end

% Something here to import a energy matrix that is 3 x n, for R, G, B n-mers. This will be used to create a different matrix 
% where each of the entries is what will actually be plotted. Like, think intensity.
% Ex. Plot(1,1) = NMers(1,1)*arbitrary intensity. Plot(1,n) can be plotted with EMatrix(1,n) to give a stick plot with stem(P) where P=[EMatrix,  Plot]
% Need a way to make each data point to be the center of a Gaussian that has some set width, and then have the total plot be the sum of each of those Gaussians. 
% The mean of each of the Gaussians will be the point it is centered on, and the std dev will be the same for all sticks. Probably will need a loop to go over 
% all the peaks and construct a long function that will just be a long concatentation of all the smaller Gaussians. 
% Ex from Matlab support
%mean=0;
%sigma=1;
%x=-3:0.01:3;
%fx=1/sqrt(2*pi)/sigma*exp(-(x-mean).^2/2/sigma/sigma);
%Making a new function to do this. 

toc;
return;