function [ListM,ListMR,ListMG,ListMB,ListA,ListAR,ListAG,ListAB,Log]=InspectListOfMols(ListOfMols,Molecules,ListM,ListMR,ListMG,ListMB,ListA,ListAR,ListAG,ListAB,CheckBack,Log,Report)

% Find Aggregates
% Loop over each molecule
for M=1:numel(ListOfMols)
    iM=ListOfMols(M);
    x=ListM(iM).x;
    y=ListM(iM).y;
    z=ListM(iM).z;
	AggTypeM = [ 3, 2, 1;...
			2, 3, 1;...
			3, 1, 2;...
			1, 3, 2;...
			2, 1, 3;...
			1, 2, 3];
    if Molecules(x+1,y,z)>0 % Check x+1
        iM2=Molecules(x+1,y,z);
		rot1 = ListM(iM).Rotation;
		rot2 = ListM(iM2).Rotation;
		AggType = AggTypeM(rot1,1);
        if ListM(iM).Agg~=ListM(iM2).Agg && rot1 == rot2
            % Connect this molecule's aggregate to found linked aggregate
            [ListM,ListA,Log]=ConnectAggregates(ListM(iM).Agg,ListM(iM2).Agg,ListM,ListA,Log,Report);
			if AggType == 1
				[ListMR,ListAR,Log]=ConnectAggregates(ListMR(iM).Agg,ListMR(iM2).Agg,ListMR,ListAR,Log,Report);
			elseif AggType == 2
				[ListMG,ListAG,Log]=ConnectAggregates(ListMG(iM).Agg,ListMG(iM2).Agg,ListMG,ListAG,Log,Report);
			else
				[ListMB,ListAB,Log]=ConnectAggregates(ListMB(iM).Agg,ListMB(iM2).Agg,ListMB,ListAB,Log,Report);
			end 
        end
    end
    if Molecules(x,y+1,z)>0 % Check y+1
        iM2=Molecules(x,y+1,z);
        rot1 = ListM(iM).Rotation;
		rot2 = ListM(iM2).Rotation;
		AggType = AggTypeM(rot1,2);
        if ListM(iM).Agg~=ListM(iM2).Agg && rot1 == rot2
            % Connect this molecule's aggregate to found linked aggregate
            [ListM,ListA,Log]=ConnectAggregates(ListM(iM).Agg,ListM(iM2).Agg,ListM,ListA,Log,Report);
			if AggType == 1
				[ListMR,ListAR,Log]=ConnectAggregates(ListMR(iM).Agg,ListMR(iM2).Agg,ListMR,ListAR,Log,Report);
			elseif AggType == 2
				[ListMG,ListAG,Log]=ConnectAggregates(ListMG(iM).Agg,ListMG(iM2).Agg,ListMG,ListAG,Log,Report);
			else
				[ListMB,ListAB,Log]=ConnectAggregates(ListMB(iM).Agg,ListMB(iM2).Agg,ListMB,ListAB,Log,Report);
			end 
        end
    end
    if Molecules(x,y,z+1)>0 % Check z+1
        iM2=Molecules(x,y,z+1);
        rot1 = ListM(iM).Rotation;
		rot2 = ListM(iM2).Rotation;
		AggType = AggTypeM(rot1,3);
        if ListM(iM).Agg~=ListM(iM2).Agg && rot1 == rot2
            % Connect this molecule's aggregate to found linked aggregate
            [ListM,ListA,Log]=ConnectAggregates(ListM(iM).Agg,ListM(iM2).Agg,ListM,ListA,Log,Report);
			if AggType == 1
				[ListMR,ListAR,Log]=ConnectAggregates(ListMR(iM).Agg,ListMR(iM2).Agg,ListMR,ListAR,Log,Report);
			elseif AggType == 2
				[ListMG,ListAG,Log]=ConnectAggregates(ListMG(iM).Agg,ListMG(iM2).Agg,ListMG,ListAG,Log,Report);
			else
				[ListMB,ListAB,Log]=ConnectAggregates(ListMB(iM).Agg,ListMB(iM2).Agg,ListMB,ListAB,Log,Report);
			end 
        end
    end
    if CheckBack==1
        if Molecules(x-1,y,z)>0 % Check x-1
            iM2=Molecules(x-1,y,z);
            rot1 = ListM(iM).Rotation;
			rot2 = ListM(iM2).Rotation;
			AggType = AggTypeM(rot1,1);
			if ListM(iM).Agg~=ListM(iM2).Agg && rot1 == rot2
                % Connect this molecule's aggregate to found linked aggregate
                [ListM,ListA,Log]=ConnectAggregates(ListM(iM).Agg,ListM(iM2).Agg,ListM,ListA,Log,Report);
				if AggType == 1
					[ListMR,ListAR,Log]=ConnectAggregates(ListMR(iM).Agg,ListMR(iM2).Agg,ListMR,ListAR,Log,Report);
				elseif AggType == 2
					[ListMG,ListAG,Log]=ConnectAggregates(ListMG(iM).Agg,ListMG(iM2).Agg,ListMG,ListAG,Log,Report);
				else
					[ListMB,ListAB,Log]=ConnectAggregates(ListMB(iM).Agg,ListMB(iM2).Agg,ListMB,ListAB,Log,Report);
				end 
            end
        end
        if Molecules(x,y-1,z)>0 % Check y-1
            iM2=Molecules(x,y-1,z);
            rot1 = ListM(iM).Rotation;
			rot2 = ListM(iM2).Rotation;
			AggType = AggTypeM(rot1,2);
			if ListM(iM).Agg~=ListM(iM2).Agg && rot1 == rot2
                % Connect this molecule's aggregate to found linked aggregate
                [ListM,ListA,Log]=ConnectAggregates(ListM(iM).Agg,ListM(iM2).Agg,ListM,ListA,Log,Report);
				if AggType == 1
					[ListMR,ListAR,Log]=ConnectAggregates(ListMR(iM).Agg,ListMR(iM2).Agg,ListMR,ListAR,Log,Report);
				elseif AggType == 2
					[ListMG,ListAG,Log]=ConnectAggregates(ListMG(iM).Agg,ListMG(iM2).Agg,ListMG,ListAG,Log,Report);
				else
					[ListMB,ListAB,Log]=ConnectAggregates(ListMB(iM).Agg,ListMB(iM2).Agg,ListMB,ListAB,Log,Report);
				end 
            end
        end
        if Molecules(x,y,z-1)>0 % Check z-1
            iM2=Molecules(x,y,z-1);
            rot1 = ListM(iM).Rotation;
			rot2 = ListM(iM2).Rotation;
			AggType = AggTypeM(rot1,3);
			if ListM(iM).Agg~=ListM(iM2).Agg && rot1 == rot2
                % Connect this molecule's aggregate to found linked aggregate
                [ListM,ListA,Log]=ConnectAggregates(ListM(iM).Agg,ListM(iM2).Agg,ListM,ListA,Log,Report);
				if AggType == 1
					[ListMR,ListAR,Log]=ConnectAggregates(ListMR(iM).Agg,ListMR(iM2).Agg,ListMR,ListAR,Log,Report);
				elseif AggType == 2
					[ListMG,ListAG,Log]=ConnectAggregates(ListMG(iM).Agg,ListMG(iM2).Agg,ListMG,ListAG,Log,Report);
				else
					[ListMB,ListAB,Log]=ConnectAggregates(ListMB(iM).Agg,ListMB(iM2).Agg,ListMB,ListAB,Log,Report);
				end 
            end
        end
    end
end
