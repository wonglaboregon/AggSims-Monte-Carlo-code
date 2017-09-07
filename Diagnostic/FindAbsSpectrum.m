function GridAnalysis=FindAbsSpectrum(GridAnalysis,E1constant,DelocPower,StabilityConstant,NEnergySteps,HomoBroadening)

% Find all of the exciton energies
GridAnalysis=FindAllExcitonEnergies(GridAnalysis,E1constant,DelocPower,StabilityConstant);

GridAnalysis=FindAbsorption(GridAnalysis,NEnergySteps,HomoBroadening);

GridAnalysis.Params.E1constant=E1constant;
GridAnalysis.Params.DelocPower=DelocPower;
GridAnalysis.Params.StabilityConstant=StabilityConstant;
GridAnalysis.Params.NEnergySteps=NEnergySteps;
GridAnalysis.Params.HomoBroadening=HomoBroadening;


return;