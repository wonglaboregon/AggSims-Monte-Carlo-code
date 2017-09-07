function NLiquidVTime=FindNLiquidVTime(Grid)
NT=length(Grid.Time);
for t=1:NT
  ThisGrid=Grid.Time(t).Data;
  Liquids=find(ThisGrid==1);
  NLiquidVTime(t)=length(Liquids);
end
return;