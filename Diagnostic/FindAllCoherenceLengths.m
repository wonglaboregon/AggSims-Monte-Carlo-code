function [AllCoherenceLengths,AggregateList]=FindAllCoherenceLengths(AggregateList,Report)
NT=length(AggregateList);
for t=1:NT
  NAggregates=length(AggregateList(t).List);
  AllCoherenceLengths(t).List=[];
  for a=1:NAggregates
    if Report==1
      fprintf('%d ',a);
    end
    AggregatePos=AggregateList(t).List(a).Pos;
    [CoherenceLength,CoherencePos,NMolecules]=FindCoherenceLength(AggregatePos,0);
    AggregateList(t).List(a).CoherenceLength=CoherenceLength;
    AggregateList(t).List(a).CoherencePos=CoherencePos;
    AggregateList(t).List(a).NMolecules=NMolecules;
    AllCoherenceLengths(t).List=[AllCoherenceLengths(t).List CoherenceLength];
  end
end
return;