                                                             %

clc, clear, close all, format long
%load data
%**************full tasks from each orbit************
%10 level of weigth

load('10w_14_orbit_scenario_1_10_28_12_2023.mat');

rowIndices = [1, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 16, 17, 18, 19];
%
intervalData__ = cell2mat(data_tasks(:, rowIndices));

ub = size(intervalData__,1);
lb = 1;

SearchAgents_no=30; % Number of search agents

Function_name='weight'; % Name of the test function that can be from F1 to F23 (Table 1,2,3 in the paper)

Max_iteration=200; % Maximum numbef of it0rations

rnum = 1; %rining number
%problem dimension variable
dim = 30;
% Load details of the selected benchmark function
[~, ~, ~,fobj]=Get_Functions_details(Function_name);

disp('PSO with your fram work is now tackling your problem')
tic
for i =1:10
    [best_score_PSO_with, gBest, new_seq_PSO,Ave,Sd]=AEOS_PSO_with(SearchAgents_no,Max_iteration,lb,ub,dim,fobj,rnum,intervalData__); 
    % Ensure it is a row vector using reshape
    seq(i,:) = reshape(best_score_PSO_with, 1, []);
end
time_pso_MLC = toc/10;
pso_MLC_mean_seq= mean(seq);
%pso_MLC_mean_seq = seq;
time__(1)=time_pso_MLC;

disp('GWO with your fram work is now tackling your problem')
tic
for i =1:10
    [best_so_far,new_seq_GWO,best,Best_score_gwo_with,Ave, Sd]=AEOS_GWO_with(30,200,lb,ub,dim,fobj, rnum,intervalData__); %GWO algoruthm
    %seq11(i,:) = reshape(Best_score_gwo_with, 1, []);
    seq(i,:) = reshape(Best_score_gwo_with, 1, []);
end
time_gwo_MLC = toc/10;
gwo_MLC_mean_seq= mean(seq);
%gwo_MLC_mean_seq = mean(seq11);
time__(2)=time_gwo_MLC;

disp('SA with your fram work is now tackling your problem')
tic
for i =1:10
    [SA_curve_with,Ave,Sd] = AEOS_sa_with(SearchAgents_no,Max_iteration,lb,ub,dim,fobj,rnum, intervalData__);  %SA algorithm
    seq(i,:) = reshape(SA_curve_with, 1, []);
end
time_sa_MLC = toc/10;
sa_MLC_mean_seq= mean(seq);
%sa_MLC_mean_seq = seq;
time__(3)=time_sa_MLC;

disp('GA with your fram work is now tackling your problem')
tic
for i =1:10
    [GA_curve_with,ga_seq_with,Ave,Sd]= AEOS_ga_with(SearchAgents_no,Max_iteration,lb,ub,dim,fobj,rnum,intervalData__);  %SA algorithm
    seq(i,:) = reshape(GA_curve_with, 1, []);
end
time_ga_MLC = toc/10;
ga_MLC_mean_seq= mean(seq);
%ga_MLC_mean_seq = seq;
time__(4)=time_ga_MLC;

semilogy(ga_MLC_mean_seq,'Color','k','Marker', '*')
hold on
semilogy(pso_MLC_mean_seq,'Color','r','Marker', '.')
hold on
semilogy(gwo_MLC_mean_seq,'Color','b', 'Marker', '.')
hold on
semilogy(sa_MLC_mean_seq,'Color','g', 'Marker', '.')



title('Objective space')
xlabel('Iteration');
ylabel('Best score obtained so far');
Save_data('2_orbit_3w_1_7')
axis tight
grid on
box on
% legend('LFM', 'GWO','PSO', 'EO', 'EO_m', 'SA')
legend('with', 'without')
% Set the y-axis limits with an additional unit
ylim([20, 200])

