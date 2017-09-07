function Output=ProcessRuns(ArrayOfGrids)
NGrids=length(ArrayOfGrids);
for G=1:NGrids
  % fprintf('%d: ',G);
  NLiquids(G,:)=FindNLiquidVTime(ArrayOfGrids(G));
  NParticles(G,:)=FindNParticlesVTime(ArrayOfGrids(G));
  [NAggregates(G,:),AggList(G,:)]=FindNAggregatesVTime(ArrayOfGrids(G));
  [CoherenceLength(G,:),AggList(G,:)]=FindAllCoherenceLengths(AggList(G,:),0);
  AggList(G,:)=FindStabilizationEnergies(ArrayOfGrids(G),AggList(G,:));
end
NLiquids(NGrids+1,:)=mean(NLiquids);
NParticles(NGrids+1,:)=mean(NParticles);
NAggregates(NGrids+1,:)=mean(NAggregates);
[~,Times]=size(CoherenceLength);
for t=1:Times
  CoherenceLength(NGrids+1,t).List=[];
  for G=1:NGrids
    CoherenceLength(NGrids+1,t).List=[CoherenceLength(NGrids+1,t).List CoherenceLength(G,t).List];
  end
end

Output.NLiquids=NLiquids;
Output.NParticles=NParticles;
Output.NAggregates=NAggregates;
Output.AggList=AggList;
Output.CoherenceLength=CoherenceLength;

return;