%___________________________________________________________________%
%  Grey Wold Optimizer (GWO) source codes version 1.0               %
%                                                                   %
%  Developed in MATLAB R2011b(7.13)                                 %
%                                                                   %
%  Author and programmer: Seyedali Mirjalili                        %
%                                                                   %
%         e-Mail: ali.mirjalili@gmail.com                           %
%                 seyedali.mirjalili@griffithuni.edu.au             %
%                                                                   %
%       Homepage: http://www.alimirjalili.com                       %
%                                                                   %
%   Main paper: S. Mirjalili, S. M. Mirjalili, A. Lewis             %
%               Grey Wolf Optimizer, Advances in Engineering        %
%               Software , in press,                                %
%               DOI: 10.1016/j.advengsoft.2013.12.007               %
%                                                                   %
%___________________________________________________________________%

% Particle Swarm Optimization
function [cg_curve, gBest, new_seq,Ave,Sd]=AEOS_PSO_with(N,Max_iteration,lb,ub,dim,fobj,Run_no,intervalData__)
format long
%PSO Infotmation

Vmax=6;
noP=N;
wMax=0.9;
wMin=0.2;
c1=2;
c2=2;

% Initializations
iter=Max_iteration;
vel=zeros(noP,dim);
pBestScore=zeros(noP);
pBest=zeros(noP,dim);
gBest=zeros(1,dim);
cg_curve=zeros(1,iter);

%Constraint
day_instr_on = 20*60;
orbit_instr_on = 7*60;
instr_on_off = 10;
%memory size by block
Mass = 14128;
%memory consumption block by second PAn image
block_sec = 42.93;
%instrumen off after 60 second
instr_off = 60;


%time day
t_d = 86400;

for irun=1:Run_no
% Random initialization for agents.
%time position intilizing
pos=initialization(noP,dim,ub,lb); 
%initializing index position
%pos = generateUniqueMatrix(noP,dim,lb,ub);

for i=1:noP
    pBestScore(i)=-inf;
end

% Initialize gBestScore for a minimization problem
 gBestScore=-inf;
     
    
for l=1:iter 
%     
    pos = round(pos);
    
    for i=1:size(pos,1)   
        
        
    % Return back the particles that go beyond the boundaries of the search
    % space
     Flag4ub=pos(i,:)>ub;
     Flag4lb=pos(i,:)<lb;
     pos(i,:)=(pos(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;

    %replace positions based on time
    %ID_new_pos = replace_position(pos(i,:), intervalData__, t_d);
    new_pos = dupl_constraint_with_v1(pos(i,:),intervalData__);
     
     %Calculate objective function for each particle
     fitness=fobj(new_pos(:,4), length(pos));
     %Calculate objective function for each particle
     %fitness=fobj(cell2mat(seq(:,6)), length(pos));

        %if(pBestScore(i)>fitness)
        %modified 19/12/2023
        if(pBestScore(i)<fitness)
            pBestScore(i)=fitness;
            pBest(i,:)=pos(i,:);
        end
        %if(gBestScore>fitness)
        %modified 19/12/2023
        if(gBestScore<fitness)
            gBestScore=fitness;
            gBest=pos(i,:);
            new_seq = new_pos;
        end
    end

    %Update the W of PSO
    w=wMax-l*((wMax-wMin)/iter);
    %Update the Velocity and Position of particles
    for i=1:size(pos,1)
        for j=1:size(pos,2)       
            vel(i,j)=w*vel(i,j)+c1*rand()*(pBest(i,j)-pos(i,j))+c2*rand()*(gBest(j)-pos(i,j));
            
            if(vel(i,j)>Vmax)
                vel(i,j)=Vmax;
            end
            if(vel(i,j)<-Vmax)
                vel(i,j)=-Vmax;
            end            
            pos(i,j)=pos(i,j)+vel(i,j);
        end
    end
    cg_curve(l)=gBestScore;
    Ceqfit_run(irun)=gBestScore;
end

end

Ave=mean(Ceqfit_run);
Sd=std(Ceqfit_run);
