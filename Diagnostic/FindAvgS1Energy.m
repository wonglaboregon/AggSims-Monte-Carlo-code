% Create avgabs using the function FindAvgAbs
function AvgS1Energy=FindAvgS1Energy(avgabs)
avgabs.Abs(isnan(avgabs.Abs)) = 0 ;

Norm=sum(avgabs.Abs,2);
[Nt,NE]=size(avgabs.Abs);
for t=1:Nt
AvgS1Energy(t)=sum(avgabs.Abs(t,:).*avgabs.Energy)/Norm(t);
end
return;