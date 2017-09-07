function Energy=PairEnergy(Sol1,Mol1,Sol2,Mol2,ListM,Input,Direction)
SideMatrix=[3 2 1; 2 3 1; 3 1 2; 1 3 2; 2 1 3; 1 2 3];

% Determine what's in Site1
if Mol1>0
    Site1=2; % It's a molecule
elseif Sol1==1
    Site1=1; % It's solvent
elseif Mol1<0
    Site1=-1; % It's substrate
else
    Site1=0; % It's nothing
end
% Determine what's in Site2
if Mol2>0
    Site2=2; % It's a molecule
elseif Sol2==1
    Site2=1; % It's solvent
elseif Mol2<0
    Site2=-1; % It's substrate
else
    Site2=0; % It's nothing
end

Product=Site1*Site2;
if Product==4 % Both sites have molecules
    Energy=Input.Emm(SideMatrix(ListM(Mol1).Rotation,Direction),SideMatrix(ListM(Mol2).Rotation,Direction))*Input.kT;
elseif Product==1 % both sites are solvent
    Energy=Input.Ess*Input.kT;
elseif Product==0 % At least one site is nothing
    Energy=0;
elseif Product==-2 % One site is substrate, one is molecule
    if Site1==2 % Molecule is in Site1, substrate in Site2
        Energy=Input.Emb(SideMatrix(ListM(Mol1).Rotation,Direction))*Input.kT;
    else % Molecule is in Site2, substrate in Site1
        Energy=Input.Emb(SideMatrix(ListM(Mol2).Rotation,Direction))*Input.kT;
    end
elseif Product==-1 % One site is substrate, one is solvent
    Energy=Input.Esb*Input.kT;
elseif Site1==2 % Molecule in Site1, solvent in Site2
    Energy=Input.Ems(SideMatrix(ListM(Mol1).Rotation,Direction))*Input.kT;
else % Molecule in Site2, solvent in Site1
    Energy=Input.Ems(SideMatrix(ListM(Mol2).Rotation,Direction))*Input.kT;
end

return;