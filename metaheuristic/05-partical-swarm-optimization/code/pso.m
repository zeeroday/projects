clc
clear
close all

%% PSO problem
x=importdata('X.data');
y=importdata('Y.data');
R= zeros(10,1)
Bestfitness= zeros(10,1)
for exec=1:10
    %% PSO Parameters 
    nPop=30;            % Number of particles
    MaxIt = 300;        % Maximum Number of Iterations
    c1=2.2;               % Personal Learning Coefficient
    c2=2;               % Global Learning Coefficient
    w =0.9;             % Inertia Weight
    Pv = 0.9;           % Particule sp

    r1=rand(1,nPop);    % Random for the PSO particules
    r2=rand(1,nPop);    % Random for the PSO particules

    t = 1;
    error = 0;
%% Initialization
% Speed of each particule

    for i=1:nPop
        v(i,1) = {rand(25,401)*Pv};
        v(i,2) = {rand(1,26)*Pv};
    end

    % Positions 
    for i=1:nPop
        s(i,1) = {rand(25,401)*10};
        s(i,2) = {rand(1,26)*10};
    end



    % Local Best Position 
    for i=1:nPop
        BestPos(i,1) = {zeros(25,401)};
        BestPos(i,2) = {zeros(1,26)};
    end
    % Global Best 
    GLobalBest = {zeros(25,401),zeros(1,26)};

    % Fitness
    J = Inf(1,nPop);%
    J_plot = zeros(MaxIt,1);

    JLocal_best = Inf;      % Local best F
    JGLobal_best = Inf;     % Global best F


    while t ~= MaxIt+1
        for i=1:nPop
            % Compute Best Fitn of Particle
            Tetaone = s{i,1};
            TetaTwo = s{i,2};
            J_temp = 0;
            for k=1:200
                 h = g(TetaTwo*[1 ; g(Tetaone*[1 x(k,:)]')]);
                 J_temp = J_temp + (y(k,1)-h)^2;
            end
            J(i) = J_temp/200;
            if J(i) <= JLocal_best 
                JLocal_best = J(i);
                BestPos(i,1) = s(i,1);
                BestPos(i,2) = s(i,2);
            end
        end

        % Update Global Best, Position,  Fitness
        [JG_best_temp,index] = min(J);
        if JG_best_temp < JGLobal_best
            JGLobal_best = JG_best_temp;
            GLobalBest(1,1) = s(index,1);
            GLobalBest(1,2) = s(index,2);
        end

        J_plot(t) = JGLobal_best;
        r1=rand(1,nPop);
        r2=rand(1,nPop);

        % Update particle velocity and position
        for i=1:nPop
            v{i,1} = w*v{i,1}+c1*r1(i)*(BestPos{i,1}-s{i,1})+c2*r2(i)*(GLobalBest{1,1}-s{i,1});
            v{i,2} = w*v{i,2}+c1*r1(i)*(BestPos{i,2}-s{i,2})+c2*r2(i)*(GLobalBest{1,2}-s{i,2});
            s{i,1} = s{i,1} + v{i,1};
            s{i,2} = s{i,2} + v{i,2};
        end
        t = t + 1;
    end

    %% Prediction error 
    TetaOneSol = GLobalBest{1,1};
    TetaTwoSol = GLobalBest{1,2};
    for k=1:200
         h = g(TetaTwoSol*[1 ; g(TetaOneSol*[1 x(k,:)]')]);
         %y_predict is equal to 1 if h is >= 0.5, 0 otherwise
         %we use the Matlab function round to do exactly that.
         y_predict = round(h);
         error = error + abs(y_predict-y(k,1));
    end
    
    str=strcat('Best fitness found for : ',strcat(num2str(nPop),strcat(' particles and tmax= ', num2str(MaxIt))));
    disp(str);

    plot(1:MaxIt,J_plot,'LineWidth',2);
        title( strcat('Particule Number = ',strcat(num2str(nPop),strcat(', Max It= ',num2str(MaxIt)))));
        ylabel('Best Cost');
        xlabel('Iterations');
    grid on;
    R(exec,1) = error/200   %%
    Bestfitness(exec,1) = JGLobal_best
    save([pwd, '\','results',num2str(nPop),num2str(MaxIt)])
end