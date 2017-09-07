function [ListM,ListA,Log]=ConnectAggregates(iA1,iA2,ListM,ListA,Log,Report)
% Set iA1 to be the smaller index, where all molecules from both aggregates
% will go.
iAsmaller=min(iA1,iA2);
iAlarger=max(iA1,iA2);
iA1=iAsmaller;
iA2=iAlarger;
% Set all molecules in iA2 to be part of iA1
iM=ListA(iA2).Start;
for N=1:ListA(iA2).NMolecules
    ListM(iM).Agg=iA1;
    iM=ListM(iM).Next;
end
% Link last molecule of iA1 to first molecule of iA2
if ListA(iA1).End~=0
ListM(ListA(iA1).End).Next=ListA(iA2).Start;
end
% Link first molecule of iA2 to last molecule of iA1
if ListA(iA2).Start~=0
ListM(ListA(iA2).Start).Prev=ListA(iA1).End;
end
% Set new end molecule for iA1
ListA(iA1).End=ListA(iA2).End;
% Set NMolecules for iA1 and iA2
ListA(iA1).NMolecules=ListA(iA1).NMolecules+ListA(iA2).NMolecules;
ListA(iA2).NMolecules=0;
% Change ListA Prev and Next values to jump over the old
% aggregate which no longer exists
if ListA(iA2).Prev~=0
ListA(ListA(iA2).Prev).Next=ListA(iA2).Next;
end
if ListA(iA2).Next ~=0
ListA(ListA(iA2).Next).Prev=ListA(iA2).Prev;
end
ListA(iA2).Prev=0;
ListA(iA2).Next=0;
% Set start and end molecules of iA2 to 0
ListA(iA2).Start=0;
ListA(iA2).End=0;
if Report==1
Log{end+1,1}=['Connect A' num2str(iA2) ' to A' num2str(iA1) '.'];
end
return;
