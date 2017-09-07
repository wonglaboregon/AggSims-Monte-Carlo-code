% Input:
% - Input = Output of function InputParams.m

% Calls:
% - CheckForLinks.m
% - ConnectAggregates.m

function [Grids,Log]=CreateGrids(Input)
Grids.Input=Input;
x=Input.x;
y=Input.y;
z=Input.z;
Log{1,1}='T1';

% Create grids for solvent and molecules, with zero padding
Grids.Solvent=zeros(x+2,y+2,z+2);
Grids.Molecules=zeros(x+2,y+2,z+2);
% Create row array of zeros of size that will fill grid when redimensioned
NGrid=x*y*z;

NMolecules=floor(NGrid*Input.coverage);
Molecules(1:NGrid)=0;
% Fill first NMolecules cells in array with molecule numbers 1:NMolecules
Molecules(1:NMolecules)=1:NMolecules;
% Randomly permute the elements of the array to put molecules in random
% positions.
Molecules=Molecules(randperm(NGrid));
% Create equally sized row array with 1 wherever there isn't a molecule.
Solvent=Molecules==0;
% reshape arrays to the correct dimensions0
Molecules=reshape(Molecules,x,y,z);
Solvent=reshape(Solvent,x,y,z);
% place in Grid, which includes zero padding
Grids.Solvent(2:x+1,2:y+1,2:z+1)=Solvent;
Grids.Molecules(2:x+1,2:y+1,2:z+1)=Molecules;
% Add -1 in z=1 layer of molecule grid as the substrate
Grids.Molecules(:,:,1)=-1;

% Find location of each molecule, add to list of molecules
for xi=1:x+2
    for yi=1:y+2
        for zi=1:z+2
            iM=Grids.Molecules(xi,yi,zi);
            if iM>0
                ListM(iM).x=xi;
                ListM(iM).y=yi;
                ListM(iM).z=zi;
                ListM(iM).Rotation=randi(6);
                ListM(iM).Prev=0;
                ListM(iM).Next=0;
                ListM(iM).Agg=iM;
				
				ListMR(iM).Agg=iM;
				ListMR(iM).Prev=0;
                ListMR(iM).Next=0;
				
				ListMG(iM).Agg=iM;
				ListMG(iM).Prev=0;
                ListMG(iM).Next=0;
				
				ListMB(iM).Agg=iM;
				ListMB(iM).Prev=0;
                ListMB(iM).Next=0;
            end
        end
    end
end

[ListM,ListMR,ListMG,ListMB,ListA,ListAR,ListAG,ListAB,Log]=RefindAggregates(Grids.Molecules,ListM,ListMR,ListMG,ListMB,Log,0);

% Put into Grids to output
Grids.ListM=ListM;
Grids.ListMR=ListMR;
Grids.ListMG=ListMG;
Grids.ListMB=ListMB;
Grids.ListA=ListA;
Grids.ListAR=ListAR;
Grids.ListAG=ListAG;
Grids.ListAB=ListAB;
Grids.NMolecules=NMolecules;
%Grids.NAggs=NMolecules;
return;