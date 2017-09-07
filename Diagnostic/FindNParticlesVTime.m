function NParticlesVTime=FindNParticlesVTime(Grid)
NT=length(Grid.Time);
for t=1:NT
NParticlesVTime(t)=length(Grid.Time(t).AggList);
end
return;