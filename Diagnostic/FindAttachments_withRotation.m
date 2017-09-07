function [AggregateListi,Grid]=FindAttachments_withRotation(Grid,AggregateListi,x,y,z,Report)
% x, y and z define the grid point of interest
  if Report==1
    fprintf('(%d,%d,%d)',x,y,z);
  end

[N,~,~,~]=size(AggregateListi.Pos);
MatchingValue=-Grid(x,y,z);

% check x+1, y, z to see if it is an attached molecule
if Grid(x+1,y,z)==MatchingValue
  N=N+1;
  AggregateListi.Pos(N,:)=[x+1 y z];
  Grid(x+1,y,z)=-Grid(x+1,y,z);
  [AggregateListi,Grid]=FindAttachments_withRotation(Grid,AggregateListi,x+1,y,z,Report);
  [N,~,~,~]=size(AggregateListi.Pos);
end

% check x, y+1, z to see if it is an attached molecule
if Grid(x,y+1,z)==MatchingValue
  N=N+1;
  AggregateListi.Pos(N,:)=[x y+1 z];
  Grid(x,y+1,z)=-Grid(x,y+1,z);
  [AggregateListi,Grid]=FindAttachments_withRotation(Grid,AggregateListi,x,y+1,z,Report);
  [N,~,~,~]=size(AggregateListi.Pos);
end

% check x, y, z+1 to see if it is an attached molecule
if Grid(x,y,z+1)==MatchingValue
  N=N+1;
  AggregateListi.Pos(N,:)=[x y z+1];
  Grid(x,y,z+1)=-Grid(x,y,z+1);
  [AggregateListi,Grid]=FindAttachments_withRotation(Grid,AggregateListi,x,y,z+1,Report);
  [N,~,~,~]=size(AggregateListi.Pos);
end

% check x-1, y, z to see if it is an attached molecule
if Grid(x-1,y,z)==MatchingValue
  N=N+1;
  AggregateListi.Pos(N,:)=[x-1 y z];
  Grid(x-1,y,z)=-Grid(x-1,y,z);
  [AggregateListi,Grid]=FindAttachments_withRotation(Grid,AggregateListi,x-1,y,z,Report);
  [N,~,~,~]=size(AggregateListi.Pos);
end

% check x, y-1, z to see if it is an attached molecule
if Grid(x,y-1,z)==MatchingValue
  N=N+1;
  AggregateListi.Pos(N,:)=[x y-1 z];
  Grid(x,y-1,z)=-Grid(x,y-1,z);
  [AggregateListi,Grid]=FindAttachments_withRotation(Grid,AggregateListi,x,y-1,z,Report);
  [N,~,~,~]=size(AggregateListi.Pos);
end

% check x, y, z-1 to see if it is an attached molecule
if Grid(x,y,z-1)==MatchingValue
  N=N+1;
  AggregateListi.Pos(N,:)=[x y z-1];
  Grid(x,y,z-1)=-Grid(x,y,z-1);
  [AggregateListi,Grid]=FindAttachments_withRotation(Grid,AggregateListi,x,y,z-1,Report);
  [N,~,~,~]=size(AggregateListi.Pos);
end
return;