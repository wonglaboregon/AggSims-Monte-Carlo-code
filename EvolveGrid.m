% Input:
% - Grid = Stucture for a particular timepoint, containing fields:
%           - Input = Input parameters for tihs timestep
%           - Solvent = Matrix of physical sites (0=nothing, 1=solvent)
%           - Molecules = Matrix of physical sites (#=molecule index)
%           - ListM = List of molecules, structure for each molecule:
%               - x,y,z = Location of molecule site
%               - Rotation = Rotational state of molecule
%               - Prev,Next = Previous or next molecule in the aggregate,
%               zero if at beginning/end of list
%               - Agg = Index of aggregate to which this molecule belongs
%           - ListA = List of aggregates, structure for each aggregate:
%               - Start,End = Index of molecules which start and end the
%               aggregate
%               - NMolecules = Number of molecules in this aggregate
%               - Prev,Next = The previous and next aggregate in the list
%           - NMolecules = Number of molecules in the system
% - Input = Input parameters for evolving the grid during this timestep
% - Report = Binary array to determine which changes to the grid are logged
%           (rotation, move molecule, connect, disconnect, move aggregate)

% Calls:
% GridEnergy.m
% ShiftCoords.m
% DisconnectAggregate2.m
% CheckForLinks.m
% ConnectAggregates.m

function [Grid,Log]=EvolveGrid(Grid,Input,Log,Report)
Grid.Input=Input;
kT=Input.kT;
% Evolve rotation of each molecule
% Loop over each molecule
for m=1:Grid.NMolecules
    x=Grid.ListM(m).x;
    y=Grid.ListM(m).y;
    z=Grid.ListM(m).z;
    % Only allow rotation if molecule is adjacent to at least one solvent molecule
    if (Grid.Solvent(x-1,y,z)+Grid.Solvent(x+1,y,z)+Grid.Solvent(x,y-1,z)+Grid.Solvent(x,y+1,z)+Grid.Solvent(x,y,z-1)+Grid.Solvent(x,y,z+1)>0)
        % Find current rotation state
        OrigRot=Grid.ListM(m).Rotation;
        % Determine random direction for possible rotation and what the new
        % rotational state would be
        RotDirection=randi(3);
        RotMatrix=[3 6 2;5 4 1;1 5 4;6 2 3;2 3 6;4 1 5];
        NewRot=RotMatrix(OrigRot,RotDirection);
        % Make a possible ListM with this new rotation
        NewListM=Grid.ListM;
        NewListM(m).Rotation=NewRot;
        % Find probability of this rotation by evaluating energy of surrounding
        % grid
        EOrig=GridEnergy(Grid.Molecules(x-1:x+1,y-1:y+1,z-1:z+1),Grid.Solvent(x-1:x+1,y-1:y+1,z-1:z+1),Grid.ListM,Input);
        ENew=GridEnergy(Grid.Molecules(x-1:x+1,y-1:y+1,z-1:z+1),Grid.Solvent(x-1:x+1,y-1:y+1,z-1:z+1),NewListM,Input);
        Prob=min(1,exp(-(ENew-EOrig)/(kT)));
        Random=rand;
        if Random<Prob
            Grid.ListM=NewListM;
            if Report(1)==1
                Log{end+1,1}=['Rotate M' num2str(m) ' from ' num2str(OrigRot) ' to ' num2str(NewRot) '.'];
            end
        end
    end
end

% Evolve location of each molecule
% Loop over each molecule
NAltered=0;
for m=1:Grid.NMolecules
    x=Grid.ListM(m).x;
    y=Grid.ListM(m).y;
    z=Grid.ListM(m).z;
    % Pick a random direction for movement and find coordinates of
    % destination
    Direction=randi(6);
    NewPos=ShiftCoords(x,y,z,Direction);
    % Only try to move if destination contains solvent
    if Grid.Solvent(NewPos.x,NewPos.y,NewPos.z)==1
        % Find coordinates of cropped grid and create cropped grid
        xmin=min(x,NewPos.x)-1;
        xmax=max(x,NewPos.x)+1;
        ymin=min(y,NewPos.y)-1;
        ymax=max(y,NewPos.y)+1;
        zmin=min(z,NewPos.z)-1;
        zmax=max(z,NewPos.z)+1;
        MatrixM=Grid.Molecules(xmin:xmax,ymin:ymax,zmin:zmax);
        MatrixS=Grid.Solvent(xmin:xmax,ymin:ymax,zmin:zmax);
        % Create cropped matrices and switch position of molecule and solvent
        NewM=MatrixM;
        NewS=MatrixS;
        % Find coordinates of old molecule position and new molecule
        % position in the cropped grids
        xold=x-xmin+1;
        yold=y-ymin+1;
        zold=z-zmin+1;
        xnew=NewPos.x-xmin+1;
        ynew=NewPos.y-ymin+1;
        znew=NewPos.z-zmin+1;
        % Move molecule
        NewM(xnew,ynew,znew)=NewM(xold,yold,zold);
        NewM(xold,yold,zold)=0;
        % Move solvent
        NewS(xnew,ynew,znew)=0;
        NewS(xold,yold,zold)=1;
        % Update molecule's position in ListM
        NewListM=Grid.ListM;
        NewListM(m).x=NewPos.x;
        NewListM(m).y=NewPos.y;
        NewListM(m).z=NewPos.z;
        % Find energy of current system
        Ei=GridEnergy(MatrixM,MatrixS,Grid.ListM,Input);
        % Find energy of possible new system
        Ef=GridEnergy(NewM,NewS,NewListM,Input);
        % Determine probability of the move occuring
        Prob=min(1,exp(-(Ef-Ei)/(kT)));
        % Pick a random number and decide if move occurs
        Random=rand;
        if Random<Prob
            Grid.ListM=NewListM;
            Grid.Molecules(xmin:xmax,ymin:ymax,zmin:zmax)=NewM;
            Grid.Solvent(xmin:xmax,ymin:ymax,zmin:zmax)=NewS;
            % Record that this molecule was moved and this aggregate
            % altered
            NAltered=NAltered+1;
            %MAltered(NAltered)=m;
            AAltered(NAltered)=Grid.ListM(m).Agg;
            % Add movement to log if requested
            if Report(2)==1
                Log{end+1,1}=['Move M' num2str(m) ' from (' num2str(x) ',' num2str(y) ',' num2str(z) ') to ('  num2str(NewPos.x) ',' num2str(NewPos.y) ',' num2str(NewPos.z) ').'];
            end
        end
    end
end

% Disconnect all aggregates which were altered
if NAltered>0
    % Sort lists of altered aggregates
    %     AAltered_Sorted=sort(AAltered);
    %
    %     % Determine how many molecules need to be disconnected and reconnected
    %     iA=AAltered_Sorted(1);
    %     Total=Grid.ListA(iA).NMolecules;
    %     for A=1:NAltered
    %         if AAltered_Sorted(A)~=iA
    %             iA=AAltered_Sorted(A);
    %             Total=Total+Grid.ListA(iA).NMolecules;
    %         end
    %     end
    %     % Disconnect and reconnect if Total is less than half of system
    %     if Total<0.5*Grid.NMolecules
    %
    %         % Go through each aggregate and disconnect all molecules
    %         iA=0;
    %         ListOfMols=[];
    %         for A=1:NAltered
    %             if AAltered_Sorted(A)~=iA
    %                 iA=AAltered_Sorted(A);
    %                 % Disconnect all molecules in this aggregate
    %                 [Grid.ListM,Grid.ListA,ListOfMols,Log]=DisconnectAggregate3(iA,Grid.ListM,Grid.ListA,ListOfMols,Log,Report(4));
    %             end
    %         end
    %
    %         % Go through each molecule and inspect for connections
    %         for M=1:numel(ListOfMols)
    %             % loop over each molecule
    %             iM=ListOfMols(M);
    %             LinkedList=CheckForLinks(iM,Grid.Molecules,Grid.ListM);
    %             % loop over each molecule that this molecule is linked to
    %             for Link=1:numel(LinkedList.Agg)
    %                 if Grid.ListM(iM).Agg~=LinkedList.Agg(Link) && Grid.ListA(LinkedList.Agg(Link)).Start~=0
    %                     % Connect this molecule's aggregate to found linked aggregate
    %                     [Grid.ListM,Grid.ListA,Log]=ConnectAggregates(Grid.ListM(iM).Agg,LinkedList.Agg(Link),Grid.ListM,Grid.ListA,Log,Report(3));
    %                 end
    %             end
    %         end
    %     else
    % Since too many molecules would need to be disconnected and
    % reconnected, just find all aggregates again from scratch.
    %[Grid.ListM,Grid.ListA,Log]=RefindAggregates(Grid.Molecules,Grid.ListM,Log,0);
	[Grid.ListM,Grid.ListMR,Grid.ListMG,Grid.ListMB,Grid.ListA,Grid.ListAR,Grid.ListAG,Grid.ListAB,Log]=RefindAggregates(Grid.Molecules,Grid.ListM,Grid.ListMR,Grid.ListMG,Grid.ListMB,Log,Report);
    %     end
end


% Evolve location of each aggregate
% Loop over each aggregate
iA=1;
while iA~=0
    iAnext=Grid.ListA(iA).Next;
    if iAnext~=0
        iAnextnext=Grid.ListA(iAnext).Next;
    else
        iAnextnext=0;
    end
    %%%%%display(['iA=' num2str(iA) ' iAnext=' num2str(iAnext) ' iAnextnext=' num2str(iAnextnext)]);
    % Find number of molecules in the aggregate, and only attempt to move
    % if there is more that one molecule
    if Grid.ListA(iA).NMolecules~=1
        % Pick a random direction for movement
        Direction=randi(6);
        % Keep track of max and min x,y,z values for all molecules in
        % aggregate, so we can later define a cropped grid to find energy.
        % Grids have a 1 unit buffer around active area defined in Input.
        maxx=1;
        maxy=1;
        maxz=1;
        minx=Grid.Input.x+2;
        miny=Grid.Input.y+2;
        minz=Grid.Input.z+2;
        % Loop over each molecule in aggregate, exit if can't move
        exit=0;
        stuck=0;
        iM=Grid.ListA(iA).Start;
        count=0;
        while exit==0 && count<Grid.NMolecules+1
            count=count+1;
            % Get shifted coordinates for this molecule
            NewXYZ=ShiftCoords(Grid.ListM(iM).x,Grid.ListM(iM).y,Grid.ListM(iM).z,Direction);
            % Molecule can only move if the adjacent destination site
            % contains either liquid or another molecule (which would be a
            % part of the same aggregate). Check if destination site is
            % valid for this molecule.
            if Grid.Solvent(NewXYZ.x,NewXYZ.y,NewXYZ.z)==1 || Grid.Molecules(NewXYZ.x,NewXYZ.y,NewXYZ.z)>0
                % This molecule can move.
                % Find if it expands the grid of molecules which must later
                % be evaluated for energy.
                minx=min(minx,Grid.ListM(iM).x);
                miny=min(miny,Grid.ListM(iM).y);
                minz=min(minz,Grid.ListM(iM).z);
                maxx=max(maxx,Grid.ListM(iM).x);
                maxy=max(maxy,Grid.ListM(iM).y);
                maxz=max(maxz,Grid.ListM(iM).z);
            else % Target site does not contain either solvent or molecule
                exit=1;
                stuck=1;
            end
            % Move on to next molecule
            iM=Grid.ListM(iM).Next;
            if iM==0
                exit=1;
            end
        end
        if count<Grid.NMolecules+1;
            % If molecule is not stuck, attempt the move
            if stuck==0
                % Create cropped grids
                % Find min and max coordinates of aggregate in original and
                % shifted positions by taking the min and max coordinates of
                % the original position (calculated while evaluating each
                % molecule, above), and shifting those coordinates in the
                % chosen direction, and adjusting the min and max coordinates
                % as needed. Add/subtract 1 from the resulting max/min
                % coordinates so the surrounding molecules will be included in
                % the energy evaluation.
                NewMaxXYZ=ShiftCoords(maxx,maxy,maxz,Direction);
                NewMinXYZ=ShiftCoords(minx,miny,minz,Direction);
                minx=min(minx,NewMinXYZ.x)-1;
                miny=min(miny,NewMinXYZ.y)-1;
                minz=min(minz,NewMinXYZ.z)-1;
                maxx=max(maxx,NewMaxXYZ.x)+1;
                maxy=max(maxy,NewMaxXYZ.y)+1;
                maxz=max(maxz,NewMaxXYZ.z)+1;
                MatrixM=Grid.Molecules(minx:maxx,miny:maxy,minz:maxz);
                MatrixS=Grid.Solvent(minx:maxx,miny:maxy,minz:maxz);
                NewMatrixM=MatrixM;
                NewMatrixS=MatrixS;
                NewListM=Grid.ListM;
                % Move aggregate in NewMatrixM
                iM=Grid.ListA(iA).Start;
                i=1;
%                 Old.x=zeros(Grid.ListA(iA).NMolecules);
%                 Old.y=zeros(Grid.ListA(iA).NMolecules);
%                 Old.z=zeros(Grid.ListA(iA).NMolecules);
                while iM~=0
                    % Find molecule's old location in NewMatrixM
                    OldX=Grid.ListM(iM).x-minx+1;
                    OldY=Grid.ListM(iM).y-miny+1;
                    OldZ=Grid.ListM(iM).z-minz+1;
                    % Store this location for later, when we fill empty sites
                    % with solvent.
                    Old.x(i)=OldX;
                    Old.y(i)=OldY;
                    Old.z(i)=OldZ;
                    % Place a zero at this location in NewMatrixM
                    NewMatrixM(OldX,OldY,OldZ)=0;
                    % Change location in NewListM
                    NewXYZ=ShiftCoords(OldX,OldY,OldZ,Direction);
                    NewListM(iM).x=NewXYZ.x+minx-1;
                    NewListM(iM).y=NewXYZ.y+miny-1;
                    NewListM(iM).z=NewXYZ.z+minz-1;
                    % Place molecule at new coordinates in NewMatrixM
                    NewMatrixM(NewXYZ.x,NewXYZ.y,NewXYZ.z)=iM;
                    % Make sure no solvent at this new molecule location
                    NewMatrixS(NewXYZ.x,NewXYZ.y,NewXYZ.z)=0;
                    % Move on to next molecule
                    iM=Grid.ListM(iM).Next;
                    i=i+1;
                end
                % Place solvent in old molecule positions which are not now
                % occupied by a new molecule.
                for Site=1:i-1
                    % Only fill sites which are not occupied by a new molecule
                    if NewMatrixM(Old.x(Site),Old.y(Site),Old.z(Site))==0
                        % Fill this site with solvent
                        NewMatrixS(Old.x(Site),Old.y(Site),Old.z(Site))=1;
                    end
                end
                % Find energy of current system
                Ei=GridEnergy(MatrixM,MatrixS,Grid.ListM,Input);
                % Find energy of possible new system
                Ef=GridEnergy(NewMatrixM,NewMatrixS,NewListM,Input);
                % Determine probability of the move occuring
                Prob=min(1,exp(-(Ef-Ei)/(kT)));
                % Pick a random number and decide if move occurs
                Random=rand;
                if Random<Prob
                    % Replace old with new
                    Grid.ListM=NewListM;
                    Grid.Molecules(minx:maxx,miny:maxy,minz:maxz)=NewMatrixM;
                    Grid.Solvent(minx:maxx,miny:maxy,minz:maxz)=NewMatrixS;
                    if Report(3)==1
                        Log{end+1,1}=['Move A' num2str(iA) ' in direction ' num2str(Direction) '.'];
                        %%%%%display (['Move A' num2str(iA) ' in direction ' num2str(Direction) '.']);
                    end
                    % Inspect each molecule in aggregate to see if it now connects
                    % with a different aggregate.
                    iM=Grid.ListA(iA).Start;
                    ListOfMols=[];
                    while iM~=0
                        ListOfMols(end+1)=iM;
                        iM=Grid.ListM(iM).Next;
                    end
					[Grid.ListM,Grid.ListMR,Grid.ListMG,Grid.ListMB,Grid.ListA,Grid.ListAR,Grid.ListAG,Grid.ListAB,Log]=InspectListOfMols(ListOfMols,Grid.Molecules,Grid.ListM,Grid.ListMR,Grid.ListMG,Grid.ListMB,Grid.ListA,Grid.ListAR,Grid.ListAG,Grid.ListAB,1,Log,Report);
                    %[Grid.ListM,Grid.ListA,Log]=InspectListOfMols(ListOfMols,Grid.Molecules,Grid.ListM,Grid.ListA,1,Log,1);
                end
            end
        else
            %%%%display ('count>NMolecules+1');
        end
    end
    if Grid.ListA(iA).Next==0
         iA=iAnextnext;
    else
        iA=Grid.ListA(iA).Next;
    end
end

% Vaporize solvent from the top
% Consider each x,y location (don't consider zero padding around grid)
for x=2:Input.x+1
    for y=2:Input.y+1
        % Find first z layer that is not empty (has either molecule or
        % solvent)
        Solvent=0;
        Molecule=0;
        z=Input.z+2;
        while (Solvent==0 && Molecule==0 && z>2)
            z=z-1;
            Molecule=Grid.Molecules(x,y,z);
            Solvent=Grid.Solvent(x,y,z);
        end
        % If top occupied site has solvent, attempt to vaporize it.
        if Solvent==1
            % Create cropped grids, 1 unit around site of interest
            MatrixS=Grid.Solvent(x-1:x+1,y-1:y+1,z-1:z+1);
            NewMatrixS=MatrixS;
            % Remove solvent from site of interest in NewMatrixS
            NewMatrixS(2,2,2)=0;
            % Find energy of current system
            Ei=GridEnergy(Grid.Molecules(x-1:x+1,y-1:y+1,z-1:z+1),MatrixS,Grid.ListM,Input);
            % Find energy of new system
            Ef=GridEnergy(Grid.Molecules(x-1:x+1,y-1:y+1,z-1:z+1),NewMatrixS,Grid.ListM,Input);
            % Determine probability of the move occuring
            Prob=min(1,exp(-(Ef-Ei)/kT));
            % Pick a random number and decide if move occurs
            Random=rand;
            if Random<Prob
                % Replace old with new
                Grid.Solvent(x-1:x+1,y-1:y+1,z-1:z+1)=NewMatrixS;
            end
        end
    end
end

return;