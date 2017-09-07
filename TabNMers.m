function [Grids]=TabNMers(Grids)

ListAR = Grids.ListAR;
ListAG = Grids.ListAG;
ListAB = Grids.ListAB;
NMols=numel(ListAR);
NAggsR=zeros(1,20,'uint32');
NAggsG=zeros(1,20,'uint32');
NAggsB=zeros(1,20,'uint32');
Grids.Nmers = zeros(3,50,'uint32');

for I = 1:NMols
	% Need to loop over the different ListAs and fill the location in 
	% Grids.Nmers to be the number of aggregates of each n-mer. 
	if ListAR(I).NMolecules ~= 0
		NMolecules = ListAR(I).NMolecules;
		NAggsR(NMolecules) = NAggsR(NMolecules) + 1;
		Grids.Nmers(1,NMolecules)=NAggsR(NMolecules);
	end
	if ListAG(I).NMolecules ~= 0
		NMolecules = ListAG(I).NMolecules;
		NAggsG(NMolecules) = NAggsG(NMolecules) + 1;
		Grids.Nmers(2,NMolecules)=NAggsG(NMolecules);
	end
	if ListAB(I).NMolecules ~= 0
		NMolecules = ListAB(I).NMolecules;
		NAggsB(NMolecules) = NAggsB(NMolecules) + 1;
		Grids.Nmers(3,NMolecules)=NAggsB(NMolecules);
	end
end


		