function GridAnalysis=FindAbsorption(GridAnalysis,NEnergySteps,HomoBroadening)

[NGrids,Nt]=size(GridAnalysis.AggList);

% Find biggest and smallest exciton energies, over all grids and times
Emin=1e100;
Emax=-1e100;
for t=1:Nt
  ThisEmin=min(GridAnalysis.ExcitonEnergy(NGrids+1,t).List);
  if ThisEmin<Emin
    Emin=ThisEmin;
  end
  ThisEmax=max(GridAnalysis.ExcitonEnergy(NGrids+1,t).List);
  if ThisEmax>Emax
    Emax=ThisEmax;
  end
end
% Create array of energies to evaluate
Erange=Emax-Emin+2*HomoBroadening;
Estep=Erange/(NEnergySteps-1);
Energy=[Emin-HomoBroadening:Estep:Emax+HomoBroadening];
GridAnalysis.Energy=Energy;
SumAbsSpectrum=zeros(Nt,NEnergySteps);

% Loop over each grid
for G=1:NGrids
  AbsSpectrum=zeros(Nt,NEnergySteps);
  % Loop over each time
  for t=1:Nt
    % Loop over each aggregate
    Nagg=length(GridAnalysis.AggList(G,t).List);
    for a=1:Nagg
      % Loop over each layer
      NLayer=length(GridAnalysis.AggList(G,t).List(a).ExcitonEnergy);
      for L=1:NLayer
        NMols=GridAnalysis.AggList(G,t).List(a).NMolecules(L);
        Ecentre=GridAnalysis.AggList(G,t).List(a).ExcitonEnergy(L);
        Estart=Ecentre-3*HomoBroadening;
        Eend=Ecentre+3*HomoBroadening;
        [~,E1]=min(abs(Energy-Estart));
        [~,E2]=min(abs(Energy-Eend));
        Esteps=E2-E1+1;
        %      fprintf('E1=%d,E2=%d:',E1,E2);
        % Loop over each energy within 3 broadening values of centre energy
        for s=1:Esteps
          ThisEnergy=Energy(E1+s-1);
          AbsSpectrum(t,E1+s-1)=AbsSpectrum(t,E1+s-1)+NMols*GaussianValue(ThisEnergy,Ecentre,HomoBroadening);
          %        fprintf('E=%d A=%d',ThisEnergy,AbsSpectrum(t,E1+s-1));
        end
      end
    end
  end
GridAnalysis.Absorption(G,:,:)=AbsSpectrum;
SumAbsSpectrum=SumAbsSpectrum+AbsSpectrum;
end
GridAnalysis.Absorption(NGrids+1,:,:)=SumAbsSpectrum;
return;
