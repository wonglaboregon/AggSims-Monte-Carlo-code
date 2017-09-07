function voxel2(i,d,c,alpha);

%VOXEL function to draw a 3-D voxel in a 3-D plot
%
%Usage
%   voxel(start,size,color,alpha);
%
%   will draw a voxel at 'start' of size 'size' of color 'color' and
%   transparency alpha (1 for opaque, 0 for transparent)
%   Default size is 1
%   Default color is blue
%   Default alpha value is 1
%
%   start is a three element vector [x,y,z]
%   size the a three element vector [dx,dy,dz]
%   color is a character string to specify color
%       (type 'help plot' to see list of valid colors)
%
%
%   voxel([2 3 4],[1 2 3],'r',0.7);
%   axis([0 10 0 10 0 10]);
%

%   Suresh Joel Apr 15,2003
%           Updated Feb 25, 2004

switch(nargin),
  case 0
    disp('Too few arguements for voxel');
    return;
  case 1
    l=1;    %default length of side of voxel is 1
    c='b';  %default color of voxel is blue
  case 2,
    c='b';
  case 3,
    alpha=1;
  case 4,
    %do nothing
  otherwise
    disp('Too many arguements for voxel');
end;

% Make array with coordinates of cube corners
Corners=[i(1)+[0 0 0 0 d(1) d(1) d(1) d(1)]; ...
  i(2)+[0 0 d(2) d(2) 0 0 d(2) d(2)]; ...
  i(3)+[0 d(3) 0 d(3) 0 d(3) 0 d(3)]]';

% Loop through each dimension (x, y, z)
for n=1:3,
  if n==3,
    % if on z axis, sort corners so it's ascending in z, then in x
    Corners=sortrows(Corners,[n,1]);
  else
    % if on x axis, sort corners so it's ascending in x, then in y
    % if on y axis, sort corners so it's ascending in y, then in z
    Corners=sortrows(Corners,[n n+1]);
  end;
  % Flip the 3rd and 4th corner
  temp=Corners(3,:);
  Corners(3,:)=Corners(4,:);
  Corners(4,:)=temp;
  % Draw one side of the cube
  h=patch(Corners(1:4,1),Corners(1:4,2),Corners(1:4,3),c);
  set(h,'FaceAlpha',alpha); % set its transparency
  % Flip the 7th and 8th corner
  temp=Corners(7,:);
  Corners(7,:)=Corners(8,:);
  Corners(8,:)=temp;
  % Draw the other side of the cube
  h=patch(Corners(5:8,1),Corners(5:8,2),Corners(5:8,3),c);
  set(h,'FaceAlpha',alpha); % set its transparency
end;