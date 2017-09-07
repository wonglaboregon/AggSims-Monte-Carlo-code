function GridAnalysis=FindAllExcitonEnergies(GridAnalysis,E1constant,DelocPower,StabilityConstant)
[NGrids,Nt]=size(GridAnalysis.AggList);

% Find all exciton energies
for t=1:Nt
  ExcitonEnergy(NGrids+1,t).List=[];
  for G=1:NGrids
    ExcitonEnergy(G,t).List=[];
    NAgg=length(GridAnalysis.AggList(G,t).List);
    for a=1:NAgg
      NLayers=length(GridAnalysis.AggList(G,t).List(a).CoherenceLength);
      for L=1:NLayers
        CoherenceLength=GridAnalysis.AggList(G,t).List(a).CoherenceLength(L);
        StabilizationEnergy=StabilityConstant*(GridAnalysis.AggList(G,t).List(a).CoherencePos(L).StabilizationEnergy);
        ThisExcitonEnergy=FindExcitonEnergy(CoherenceLength,E1constant,DelocPower,StabilizationEnergy);
        GridAnalysis.AggList(G,t).List(a).ExcitonEnergy(L)=ThisExcitonEnergy;
        ExcitonEnergy(G,t).List=[ExcitonEnergy(G,t).List ThisExcitonEnergy];
      end
    end
    ExcitonEnergy(NGrids+1,t).List=[ExcitonEnergy(NGrids+1,t).List ExcitonEnergy(G,t).List];
  end
end
GridAnalysis.ExcitonEnergy=ExcitonEnergy;

return;