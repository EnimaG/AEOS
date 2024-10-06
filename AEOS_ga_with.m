function [BestCost,best_seq,Ave,Sd] = AEOS_ga_with(SearchAgents_no,Max_iter,lb,ub,dim,fobj,Run_no,intervalData__)
%%
CostFunction= fobj;     % Cost Function

nVar=dim;             % Number of Decision Variables

VarSize=[1 nVar];   % Decision Variables Matrix Size

VarMin=lb;         % Lower Bound of Variables
VarMax= ub;         % Upper Bound of Variables

%% GA Parameters

MaxIt=Max_iter;      % Maximum Number of Iterations

nPop=SearchAgents_no;        % Population Size

pc=0.7;                 % Crossover Percentage
nc=2*round(pc*nPop/2);  % Number of Offsprings (Parnets)

pm=0.3;                 % Mutation Percentage
nm=round(pm*nPop);      % Number of Mutants

gamma=0.05;

mu=0.02;         % Mutation Rate

beta=8;         % Selection Pressure


%% Initialization
for irun=1:Run_no
empty_individual.Position=[];
empty_individual.Cost=[];
empty_individual.seq=[];

pop=repmat(empty_individual,nPop,1);

for i=1:nPop
    
    % Initialize Position
    pop(i).Position=round(unifrnd(VarMin,VarMax,VarSize));
    new_seq = dupl_constraint_with_v1(pop(i).Position,intervalData__);
    
    
    % Evaluation
    pop(i).Cost = CostFunction(new_seq(:,4),0);
    pop(i).seq = new_seq;
    
end

% Sort Population
Costs=[pop.Cost];
[Costs, SortOrder]=sort(Costs, 'descend');
pop=pop(SortOrder);

% Store Best Solution
BestSol=pop(1);

% Array to Hold Best Cost Values
BestCost=zeros(MaxIt,1);

% Store Cost
WorstCost=pop(end).Cost;


%% Main Loop

for it=1:MaxIt
    
    P=exp(-beta*Costs/WorstCost);
    P=P/sum(P);
    
    % Crossover
    popc=repmat(empty_individual,nc/2,2);
    for k=1:nc/2
        
        % Select Parents Indices
        i1=RouletteWheelSelection(P);
        i2=RouletteWheelSelection(P);

        % Select Parents
        p1=pop(i1);
        p2=pop(i2);
        
        % Apply Crossover
        [popc(k,1).Position, popc(k,2).Position]=...
            Crossover(p1.Position,p2.Position,gamma,VarMin,VarMax);

        %%
        new_seq_k1 = dupl_constraint_with_v1(round(popc(k,1).Position),intervalData__);
        new_seq_k2 = dupl_constraint_with_v1(round(popc(k,2).Position),intervalData__);
%         [ppopc(k,1).Position, new_seq_k1] = dupl_constraint(round(popc(k,1).Position),lb,ub, data_tasks);
%         [ppopc(k,2).Position, new_seq_k2] = dupl_constraint(round(popc(k,2).Position),lb,ub, data_tasks);

        %%
        
        % Evaluate Offsprings
        popc(k,1).Cost=CostFunction(new_seq_k1(:,4),0);
        popc(k,1).seq = new_seq_k1;
        popc(k,2).Cost=CostFunction(new_seq_k2(:,4),0);
        popc(k,2).seq = new_seq_k2;
        
    end
    popc=popc(:);
    
    
    % Mutation
    popm=repmat(empty_individual,nm,1);
    for k=1:nm
        
        % Select Parent
        i=randi([1 nPop]);
        p=pop(i);
        
        % Apply Mutation
        popm(k).Position=Mutate(p.Position,mu,VarMin,VarMax);

        new_seq_f = dupl_constraint_with_v1(round(popm(k).Position),intervalData__);

%        [ppopc(k).Position, new_seq_f] = dupl_constraint(round(popc(k).Position),lb,ub, data_tasks);

        
        % Evaluate Mutant
        popm(k).Cost=CostFunction(new_seq_f(:,4),0);
        popm(k).seq = new_seq_f;
        
    end
    
    % Create Merged Population
    pop=[pop
         popc
         popm]; %#ok
     
    % Sort Population
    Costs=[pop.Cost];
    [Costs, SortOrder]=sort(Costs, 'descend');
    pop=pop(SortOrder);
    
    % Update Worst Cost
    WorstCost=min(WorstCost,pop(end).Cost);
    
    % Truncation
    pop=pop(1:nPop);
    Costs=Costs(1:nPop);
    
    % Store Best Solution Ever Found
    BestSol=pop(1);
    
    % Store Best Cost Ever Found
    BestCost(it)=BestSol.Cost;
    Ceqfit_run(irun)=BestSol.Cost;
    best_seq = BestSol.seq;
    
    % Show Iteration Information
%     disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
end


end
Ave=mean(Ceqfit_run);
Sd=std(Ceqfit_run);
%% Results

% figure;
% semilogy(BestCost,'LineWidth',2);
% ylabel('Cost');
