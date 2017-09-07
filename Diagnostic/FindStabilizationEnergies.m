function AggList=FindStabilizationEnergies(WholeGrid,AggList)
Params=WholeGrid.Params;
Nt=length(AggList);

% loop over time
for t=1:Nt
  Grid=WholeGrid.Time(t).Data;
  % loop over each aggregate in the grid at this time
  NAgg=length(AggList(t).List);
  for a=1:NAgg
    % loop over each layer in this aggregate
    NLayers=length(AggList(t).List(a).CoherencePos);
    for L=1:NLayers
      Pos=AggList(t).List(a).CoherencePos(L).Pos;
      StabilizationEnergy=FindStabilizationEnergy(Grid,Params,Pos);
      AggList(t).List(a).CoherencePos(L).StabilizationEnergy=StabilizationEnergy;
    end
    
  end
end
return;