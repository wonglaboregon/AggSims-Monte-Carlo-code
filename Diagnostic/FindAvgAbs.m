% absarray should be of the form [RunNumber,time,energy]
% I usually make this array by hand using a command like:
% absarray(1,:,:)=GridAnalysis_1_10.Absorption(11,:,:);
% energyarray is an array of energies which match up with the array of
% absorption spectra. I usually make this array by hand using a command
% like:
% energyarray(1,:)=GridAnalysis_1_10.Energy;
function AvgAbs=FindAvgAbs(absarray,energyarray)

% Find number of energy points
[NAbs,NT,NEnergy]=size(absarray);

% Find biggest and smallest energy
minE=min(squeeze(energyarray(:,1)));
maxE=max(squeeze(energyarray(:,end)));

% Make new energy axis
Estep=(maxE-minE)/(NEnergy-1);
NewEnergy=(minE:Estep:maxE);

% Interpolate each absorption array onto new energy axis
for A=1:NAbs
  for t=1:NT
    NewAbs(A,t,:)=interp1(squeeze(energyarray(A,:)),squeeze(absarray(A,t,:)),NewEnergy);
  end
end

% Average all interpolated absorption arrays
AvgAbs.Abs=squeeze(mean(NewAbs));
AvgAbs.Energy=NewEnergy;
return;