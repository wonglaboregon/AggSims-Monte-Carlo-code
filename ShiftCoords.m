function coords=ShiftCoords(x,y,z,Direction)
coords.x=x;
coords.y=y;
coords.z=z;
if Direction==1
    coords.x=x-1;
elseif Direction==2
    coords.x=x+1;
elseif Direction==3
    coords.y=y-1;
elseif Direction==4
    coords.y=y+1;
elseif Direction==5
    coords.z=z-1;
elseif Direction==6
    coords.z=z+1;
else
    display ('ERROR: Direction>6');
end
return;