function StabilizationEnergy=FindStabilizationEnergy(Grid,Params,ExcitonPosition)
[Nmolecules,~]=size(ExcitonPosition);

PaddedGrid=PadGrid(Grid);
PaddedGrid=PadGridFront(PaddedGrid);
ExcitonPosition=ExcitonPosition+1;
StabilizationEnergy=0;

if Nmolecules==1
  x=ExcitonPosition(1);
  y=ExcitonPosition(2);
  z=ExcitonPosition(3);
  StabilizationEnergy=StabilizationEnergy-PairEnergy(PaddedGrid(x,y,z),PaddedGrid(x+1,y,z),Params,1);
  StabilizationEnergy=StabilizationEnergy-PairEnergy(PaddedGrid(x,y,z),PaddedGrid(x,y+1,z),Params,2);
  StabilizationEnergy=StabilizationEnergy-PairEnergy(PaddedGrid(x,y,z),PaddedGrid(x,y,z+1),Params,3);
  StabilizationEnergy=StabilizationEnergy-PairEnergy(PaddedGrid(x,y,z),PaddedGrid(x-1,y,z),Params,1);
  StabilizationEnergy=StabilizationEnergy-PairEnergy(PaddedGrid(x,y,z),PaddedGrid(x,y-1,z),Params,2);
  StabilizationEnergy=StabilizationEnergy-PairEnergy(PaddedGrid(x,y,z),PaddedGrid(x,y,z-1),Params,3);
else
  % Find which direction the exciton is going
  if ExcitonPosition(1,1)==ExcitonPosition(2,1) % if the x position of the first two molecules is the same, exciton must be going in the y direction
    for m=1:Nmolecules
      x=ExcitonPosition(m,1);
      y=ExcitonPosition(m,2);
      z=ExcitonPosition(m,3);
      if m==1
        StabilizationEnergy=StabilizationEnergy-PairEnergy(PaddedGrid(x,y,z),PaddedGrid(x,y-1,z),Params,2);
      elseif m==Nmolecules
        StabilizationEnergy=StabilizationEnergy-PairEnergy(PaddedGrid(x,y,z),PaddedGrid(x,y+1,z),Params,2);
      end
      StabilizationEnergy=StabilizationEnergy-PairEnergy(PaddedGrid(x,y,z),PaddedGrid(x+1,y,z),Params,1);
      StabilizationEnergy=StabilizationEnergy-PairEnergy(PaddedGrid(x,y,z),PaddedGrid(x,y,z+1),Params,3);
      StabilizationEnergy=StabilizationEnergy-PairEnergy(PaddedGrid(x,y,z),PaddedGrid(x-1,y,z),Params,1);
      StabilizationEnergy=StabilizationEnergy-PairEnergy(PaddedGrid(x,y,z),PaddedGrid(x,y,z-1),Params,3);
    end
  else % exciton must be going in the x direction
    for m=1:Nmolecules
      x=ExcitonPosition(m,1);
      y=ExcitonPosition(m,2);
      z=ExcitonPosition(m,3);
      if m==1
        StabilizationEnergy=StabilizationEnergy-PairEnergy(PaddedGrid(x,y,z),PaddedGrid(x-1,y,z),Params,1);
      elseif m==Nmolecules
        StabilizationEnergy=StabilizationEnergy-PairEnergy(PaddedGrid(x,y,z),PaddedGrid(x+1,y,z),Params,1);
      end
      StabilizationEnergy=StabilizationEnergy-PairEnergy(PaddedGrid(x,y,z),PaddedGrid(x,y+1,z),Params,2);
      StabilizationEnergy=StabilizationEnergy-PairEnergy(PaddedGrid(x,y,z),PaddedGrid(x,y,z+1),Params,3);
      StabilizationEnergy=StabilizationEnergy-PairEnergy(PaddedGrid(x,y,z),PaddedGrid(x,y-1,z),Params,2);
      StabilizationEnergy=StabilizationEnergy-PairEnergy(PaddedGrid(x,y,z),PaddedGrid(x,y,z-1),Params,3);
    end
  end
end
StabilizationEnergy=J2eV(StabilizationEnergy);
return;