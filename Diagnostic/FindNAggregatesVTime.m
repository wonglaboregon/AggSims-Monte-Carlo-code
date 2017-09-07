function [NAggregatesVTime,Aggregates]=FindNAggregatesVTime(Grid)
NT=length(Grid.Time);
for t=1:NT
  [AggregateList,~]=FindAggregates(Grid.Time(t).Data,1,0);
  Aggregates(t).List=AggregateList;
  NAggregatesVTime(t)=length(AggregateList);
end
return;