function [GaussPlot,x] = PlotAbsorbanceVsTime(FullGrid,EnergyGrid,StdDev)

% Need to find the min of all the monomers and use that number for the monomers. 
% Then need to find values of each of the nmers and energies, going to plot them vs the energy, like 
% stem(energy(2,2:end),FullGrid(100).Nmers(2,2:end)) which makes a stem plot. 
% each of the nmer energies will be the mean of each of the gaussian fits, with the scaling factor being the number of nmers. 

EnergyMax = EnergyGrid(1,1);
EnergyMin = EnergyMax;
[r,c] = size(EnergyGrid);
time=numel(FullGrid);
for m = 1:r
	for n = 1:c
		EnergyMax = max(EnergyGrid(m,n),EnergyMax);
		EnergyMin = min(EnergyGrid(m,n),EnergyMin);
    end
end

xSteps = (EnergyMax-EnergyMin)/(1000*EnergyMax);
x = EnergyMin:xSteps:EnergyMax;
GaussPlot=zeros(time,numel(x));
NMono=zeros(time,1);
for T = 1:time
	NMono(T,1) = min(FullGrid(T).Nmers(1,1),min(FullGrid(T).Nmers(2,1),FullGrid(T).Nmers(3,1)));
	GaussPlot(T,1:end) = NMono(T,1)*gaussmf(x,[StdDev EnergyGrid(1,1)]);
	[r,c] = size(FullGrid(T).Nmers);
	for m = 1:r
		for n = 2:c
			if FullGrid(T).Nmers(m,n) ~= 0
				GaussPlot(T,1:end) = GaussPlot(T,1:end) +FullGrid(T).Nmers(m,n)*gaussmf(x,[StdDev EnergyGrid(m,n)]);
			end
		end
	end
end