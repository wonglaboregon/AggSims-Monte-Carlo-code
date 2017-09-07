function [ListM,ListA,Log]=InspectListOfMols(ListOfMols,Molecules,ListM,ListA,CheckBack,Log,Report)

% Find Aggregates
% Loop over each molecule
for M=1:numel(ListOfMols)
    iM=ListOfMols(M);
    x=ListM(iM).x;
    y=ListM(iM).y;
    z=ListM(iM).z;
    if Molecules(x+1,y,z)>0 % Check x+1
        iM2=Molecules(x+1,y,z);
        if ListM(iM).Agg~=ListM(iM2).Agg
            % Connect this molecule's aggregate to found linked aggregate
            [ListM,ListA,Log]=ConnectAggregates(ListM(iM).Agg,ListM(iM2).Agg,ListM,ListA,Log,Report);
        end
    end
    if Molecules(x,y+1,z)>0 % Check y+1
        iM2=Molecules(x,y+1,z);
        if ListM(iM).Agg~=ListM(iM2).Agg
            % Connect this molecule's aggregate to found linked aggregate
            [ListM,ListA,Log]=ConnectAggregates(ListM(iM).Agg,ListM(iM2).Agg,ListM,ListA,Log,Report);
        end
    end
    if Molecules(x,y,z+1)>0 % Check z+1
        iM2=Molecules(x,y,z+1);
        if ListM(iM).Agg~=ListM(iM2).Agg
            % Connect this molecule's aggregate to found linked aggregate
            [ListM,ListA,Log]=ConnectAggregates(ListM(iM).Agg,ListM(iM2).Agg,ListM,ListA,Log,Report);
        end
    end
    if CheckBack==1
        if Molecules(x-1,y,z)>0 % Check x-1
            iM2=Molecules(x-1,y,z);
            if ListM(iM).Agg~=ListM(iM2).Agg
                % Connect this molecule's aggregate to found linked aggregate
                [ListM,ListA,Log]=ConnectAggregates(ListM(iM).Agg,ListM(iM2).Agg,ListM,ListA,Log,Report);
            end
        end
        if Molecules(x,y-1,z)>0 % Check y-1
            iM2=Molecules(x,y-1,z);
            if ListM(iM).Agg~=ListM(iM2).Agg
                % Connect this molecule's aggregate to found linked aggregate
                [ListM,ListA,Log]=ConnectAggregates(ListM(iM).Agg,ListM(iM2).Agg,ListM,ListA,Log,Report);
            end
        end
        if Molecules(x,y,z-1)>0 % Check z-1
            iM2=Molecules(x,y,z-1);
            if ListM(iM).Agg~=ListM(iM2).Agg
                % Connect this molecule's aggregate to found linked aggregate
                [ListM,ListA,Log]=ConnectAggregates(ListM(iM).Agg,ListM(iM2).Agg,ListM,ListA,Log,Report);
            end
        end
    end
end
