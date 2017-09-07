function ExcitonEnergy=FindExcitonEnergy(CoherenceLength,C,n,StabilizationEnergy)
%C=E1constant*(UnitLength^2);
ExcitonEnergy=C/((CoherenceLength)^n)+StabilizationEnergy;


return;