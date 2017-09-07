function [ListM,ListMR,ListMG,ListMB,ListA,ListAR,ListAG,ListAB,Log]=RefindAggregates(Molecules,ListM,ListMR,ListMG,ListMB,Log,Report)

NMolecules=numel(ListM);

% Create list of molecules and aggregates
for M=1:NMolecules
    ListA(M).Start=M;
    ListA(M).End=M;
    ListA(M).NMolecules=1;
    ListA(M).Prev=M-1;
    ListA(M).Next=M+1;
    ListM(M).Agg=M;
	
	ListAR(M).Start=M;
    ListAR(M).End=M;
    ListAR(M).NMolecules=1;
    ListAR(M).Prev=M-1;
    ListAR(M).Next=M+1;
    ListMR(M).Agg=M;
	
	ListAG(M).Start=M;
    ListAG(M).End=M;
    ListAG(M).NMolecules=1;
    ListAG(M).Prev=M-1;
    ListAG(M).Next=M+1;
    ListMG(M).Agg=M;
	
	ListAB(M).Start=M;
    ListAB(M).End=M;
    ListAB(M).NMolecules=1;
    ListAB(M).Prev=M-1;
    ListAB(M).Next=M+1;
    ListMB(M).Agg=M;
	
end
ListA(NMolecules).Next=0;
ListAR(NMolecules).Next=0;
ListAG(NMolecules).Next=0;
ListAB(NMolecules).Next=0;


% Find Aggregates
% Loop over each molecule
ListOfMols=1:NMolecules;
[ListM,ListMR,ListMG,ListMB,ListA,ListAR,ListAG,ListAB,Log]=InspectListOfMols(ListOfMols,Molecules,ListM,ListMR,ListMG,ListMB,ListA,ListAR,ListAG,ListAB,1,Log,Report);


return;