function GridAnalysis=FindRatesOfSF(GridAnalysis,E_TT_eV)
GridAnalysis.Params.E_TT_eV=E_TT_eV;
GridAnalysis.k_SFvsEnergy=FindRateOfET(GridAnalysis.Energy,E_TT_eV,0.103,1400,0.2,70,0.072,298);

[NGrids,NT,NE]=size(GridAnalysis.Absorption);

for t=1:NT
  Absorption=reshape(GridAnalysis.Absorption(NGrids,t,:),1,[]);
  Normalization=sum(Absorption);
  AllSFrates=GridAnalysis.k_SFvsEnergy.*Absorption/Normalization;
  SFrate(t)=mean(AllSFrates);
end

GridAnalysis.SFrate=SFrate;

return;