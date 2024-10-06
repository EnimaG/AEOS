
function [BestCost,Ave,Sd] = AEOS_sa_with(SearchAgents_no,Max_iter,lb,ub,dim,fobj,Run_no,intervalData__)
%% Problem Definition

CostFunction = fobj;    % Cost Function

nVar = dim;              % Number of Decision (Unknwon) Variables

VarSize = [1 nVar];     % Decision Variables Matrix Size

VarMin = lb;           % Lower Bound of Decision Variables
VarMax = ub;           % Upper Bound of Decision Variables


%% SA Parameters

MaxIt = Max_iter;     % Maximum Number of Iterations

MaxSubIt = 1;    % Maximum Number of Sub-iterations

T0 = 0.1;       % Initial Temp.

alpha = 0.99;     % Temp. Reduction Rate

nPop = SearchAgents_no;        % Population Size

nMove = 2;        % Number of Neighbors per Individual

mu = 0.5;       % Mutation Rate

sigma = 0.1*(VarMax-VarMin);    % Mutation Range (Standard Deviation)


%% Initialization
for irun=1:Run_no
% Create Empty Structure for Individuals
empty_individual.Position = [];
empty_individual.Cost = [];

% Create Population Array
pop = repmat(empty_individual, nPop, 1);

% Initialize Best Solution
BestSol.Cost = -inf;

% Initialize Population
% position = initialization(SearchAgents_no,dim,ub,lb); 
for i = 1:nPop

    % Initialize Position
    pop(i).Position = round(unifrnd(VarMin, VarMax, VarSize));
    new_pos = dupl_constraint_with_v1(pop(i).Position,intervalData__);
    
    
    % Evaluation
    pop(i).Cost = CostFunction(new_pos(:,4),0);
    pop(i).seq = new_pos;
    
    % Update Best Solution
    if pop(i).Cost > BestSol.Cost
        BestSol = pop(i);
    end
    
end

% Array to Hold Best Cost Values
BestCost = zeros(MaxIt, 1);

% Intialize Temp.
T = T0;

%% SA Main Loop

for it = 1:MaxIt
    
    for subit = 1:MaxSubIt
        
        % Create and Evaluate New Solutions
        newpop = repmat(empty_individual, nPop, nMove);
        for i = 1:nPop
         
            for j = 1:nMove
                
                % Create Neighbor
                newpop(i, j).Position = round(SA_Mutate(pop(i).Position, mu, sigma, VarMin, VarMax));
                %replace positions based on idx
                new_pos = dupl_constraint_with_v1(pop(i).Position,intervalData__);
                
                % Evaluation
                newpop(i, j).Cost = CostFunction(new_pos(:,4),0);
                newpop(i, j).seq = new_pos;
                
            end
        end
        newpop = newpop(:);
        
        % Sort Neighbors
        [~, SortOrder] = sort([newpop.Cost], 'descend');
        newpop = newpop(SortOrder);
        
        for i = 1:nPop
            
            %if newpop(i).Cost <= pop(i).Cost
            if newpop(i).Cost > pop(i).Cost
                pop(i) = newpop(i);
                
            else
                DELTA = (newpop(i).Cost-pop(i).Cost)/pop(i).Cost;
                P = exp(-DELTA/T);
                if rand <= P
                    pop(i) = newpop(i);
                end
            end
            
            % Update Best Solution Ever Found
            if pop(i).Cost > BestSol.Cost
                BestSol = pop(i);
            end
        
        end

    end
    
    % Store Best Cost Ever Found
    BestCost(it) = BestSol.Cost;
    Ceqfit_run(irun)=BestSol.Cost;
    
    % Display Iteration Information
%     disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
    % Update Temp.
    T = alpha*T;
    
    sigma = 0.98*sigma;
    
end

end

Ave=mean(Ceqfit_run);
Sd=std(Ceqfit_run);
