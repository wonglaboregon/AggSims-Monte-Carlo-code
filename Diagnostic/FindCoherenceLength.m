function [CoherenceLength,PosList,NMols]=FindCoherenceLength(AggregatePos,Report)

SortZY=sortrows(AggregatePos,[3 2 1]); % Use to find lengths along X
SortZX=sortrows(AggregatePos,[3 1 2]); % Use to find lengths along Y
[Nmolecules,~]=size(SortZY);

if Nmolecules==1
  CoherenceLength=1;
  PosList(1).Pos=AggregatePos;
  NMols=1;
else
  MaxLengthThisZ=1;
  Level=1;
  LevelMols=1;
  z=SortZY(1,3);
  y=SortZY(1,2);
  x=SortZY(1,1);
  ThisLength=1;
  ThisPosList(1,:)=[x y z];
  if Report==1
    fprintf('\nZY: ');
  end
  for n=2:Nmolecules
    if Report==1
      fprintf('%d ',n);
    end
    % if this molecule is adjacent to the previous molecule
    if SortZY(n,3)==z && SortZY(n,2)==y && SortZY(n,1)==x+1
      if Report==1
        fprintf('x+1 ');
      end
      ThisLength=ThisLength+1; % add to the length of this exciton
      LevelMols=LevelMols+1;
      ThisPosList(ThisLength,:)=[x+1 y z]; % record this position in the position list for this exciton
    end
    % if this molecule is not adjacent to the previous moleulce, or if it's
    % the last molecule
    if SortZY(n,3)~=z || SortZY(n,2)~=y || SortZY(n,1)~=x+1 || n==Nmolecules
      % if this exciton was the largest one so far on this level
      if ThisLength>=MaxLengthThisZ
        if Report==1
          fprintf('New: %d ',ThisLength);
        end
        MaxLengthThisZ=ThisLength; % change the maximum exciton size
        PosList(Level).Pos=ThisPosList; % record this exciton position list
      end
      % if this molecule is at a new level
      if SortZY(n,3)~=z || n==Nmolecules % At a new z level
        CoherenceLength(Level)=MaxLengthThisZ; % record the max exciton length for this level
        NMols(Level)=LevelMols;
        LevelMols=1;
        if Report==1
          fprintf('CoherenceLength(%d)=%d\n',Level,CoherenceLength(Level));
        end
        MaxLengthThisZ=1; % re-set the max length to 1 for the new level
        Level=Level+1; % move to the new level
        if Report==1
          fprintf('Level: %d ',Level);
        end
        z=SortZY(n,3); % set the new first molecule to be this molecule on the new level
        y=SortZY(n,2);
      else % if not a new level, just a different y value
        y=SortZY(n,2); % set the new first molecule to be this molecule with the new y value
        LevelMols=LevelMols+1;
        if Report==1
          fprintf('y: %d ',y);
        end
      end
      ThisLength=1; % reset the current exciton length to 1
      ThisPosList=[]; % clear the position list
      ThisPosList(1,:)=[SortZY(n,1) SortZY(n,2) SortZY(n,3)]; % set first position to be this molecule
    end
    x=SortZY(n,1); % set the new first molecule to have this x value
  end
  
  Level=1;
  MaxLengthThisZ=CoherenceLength(Level);
  z=SortZX(1,3);
  y=SortZX(1,2);
  x=SortZX(1,1);
  ThisLength=1;
  ThisPosList=[];
  ThisPosList(1,:)=[x y z];
  if Report==1
    fprintf('\nZY: ');
  end
  for n=2:Nmolecules
    if Report==1
      fprintf('%d ',n);
    end
    % if this molecule is adjacent to the previous molecule
    if SortZX(n,3)==z && SortZX(n,2)==y+1 && SortZX(n,1)==x
      if Report==1
        fprintf('y+1 ');
      end
      ThisLength=ThisLength+1; % add to the length of this exciton
      ThisPosList(ThisLength,:)=[x y+1 z]; % record this position in the position list for this exciton
    end
    % if this molecule is not adjacent to the previous moleulce, or if it's
    % the last molecule
    if SortZX(n,3)~=z || SortZX(n,2)~=y+1 || SortZX(n,1)~=x || n==Nmolecules
      % if this exciton was the largest one so far on this level
      if ThisLength>=MaxLengthThisZ
        if Report==1
          fprintf('New: %d ',ThisLength);
        end
        MaxLengthThisZ=ThisLength; % change the maximum exciton size
        PosList(Level).Pos=ThisPosList; % record this exciton position list
      end
      % if this molecule is at a new level
      if SortZX(n,3)~=z || n==Nmolecules % At a new z level
        CoherenceLength(Level)=MaxLengthThisZ; % record the max exciton length for this level
        if Report==1
          fprintf('CoherenceLength(%d)=%d\n',Level,CoherenceLength(Level));
        end
        if SortZX(n,3)~=z && n~=Nmolecules
          Level=Level+1; % move to the new level
        if Report==1
          fprintf('Level: %d ',Level);
        end
          MaxLengthThisZ=CoherenceLength(Level); % re-set the max length to 1 for the new level
          z=SortZX(n,3); % set the new first molecule to be this molecule on the new level
          x=SortZX(n,1);
        end
      else % if not a new level, just a different x value
        x=SortZX(n,1); % set the new first molecule to be this molecule with the new x value
        if Report==1
          fprintf('x: %d ',x);
        end
      end
      ThisLength=1; % reset the current exciton length to 1
      ThisPosList=[]; % clear the position list
      ThisPosList(1,:)=[SortZX(n,1) SortZX(n,2) SortZX(n,3)]; % set first position to be this molecule
    end
    y=SortZX(n,2); % set the new first molecule to have this y value
  end
  
  
  %
  %
  %     if SortZX(n,3)==z && SortZX(n,1)==x && SortZX(n,2)==y+1 && n<Nmolecules
  %       ThisLength=ThisLength+1;
  %       y=y+1;
  %       ThisPosList(ThisLength,:)=[x y z];
  %     else
  %       if ThisLength>=MaxLengthThisZ
  %         MaxLengthThisZ=ThisLength;
  %         PosList(Level).Pos=ThisPosList;
  %       end
  %       if SortZX(n,3)~=z || n==Nmolecules
  %         if MaxLengthThisZ>CoherenceLength(Level);
  %           CoherenceLength(Level)=MaxLengthThisZ;
  %         end
  %         MaxLengthThisZ=1;
  %         Level=Level+1;
  %         z=SortZX(n,3);
  %       else
  %         x=SortZX(n,1);
  %       end
  %       ThisLength=1;
  %       y=SortZX(n,2);
  %       ThisPosList=[];
  %       ThisPosList(1,:)=[x y z];
  %     end
  %   end
end
return;