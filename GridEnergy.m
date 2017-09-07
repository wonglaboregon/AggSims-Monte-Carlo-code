function Energy=GridEnergy(MatrixM,MatrixS,ListM,Input)

% Start with energy=0
Energy=0;

% Loop over sites from the original grid. Stop at size-1 so no evaluations
% of sites beyond size of grid.
[SizeX,SizeY,SizeZ]=size(MatrixM);
for x=1:SizeX-1
  for y=1:SizeY-1
    for z=1:SizeZ-1
        % Include solvent chemical potential if this site contains solvent
      if MatrixS(x,y,z)==1
        Energy=Energy-Input.Ecp*Input.kT;
      end
      % Subtract stabilization energy from interaction of this site with
      % sites at x+1, y+1, and z+1. Since all sites are considered,
      % considering x-1, y-1, z-1 would cause double-counting.
      Energy=Energy-PairEnergy(MatrixS(x,y,z),MatrixM(x,y,z),MatrixS(x+1,y,z),MatrixM(x+1,y,z),ListM,Input,1);
      Energy=Energy-PairEnergy(MatrixS(x,y,z),MatrixM(x,y,z),MatrixS(x,y+1,z),MatrixM(x,y+1,z),ListM,Input,2);
      Energy=Energy-PairEnergy(MatrixS(x,y,z),MatrixM(x,y,z),MatrixS(x,y,z+1),MatrixM(x,y,z+1),ListM,Input,3);
    end
  end
end

return;