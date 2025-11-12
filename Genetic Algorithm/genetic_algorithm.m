%% Genetic algorithm for fuzzy logic optimisation 

% Load data 
% Training on May 2024 data 
clear all; close all
load("mayData.mat");
price = table2array(mayData.Data);

% Populate bounds 
lb = [-100; -100; -100; 0; 0; 0; -12; -12; -12];
ub = [400; 400; 400; 1; 1; 1; 12; 12; 12];

% Constraints for MF formation
constraint_matrix = [1 -1 0 0 0 0 0 0 0;
                     0 1 -1 0 0 0 0 0 0;
                     0 0 0 1 -1 0 0 0 0;
                     0 0 0 0 1 -1 0 0 0;
                     0 0 0 0 0 0 1 -1 0;
                     0 0 0 0 0 0 0 1 -1];
bound_matrix = zeros(6,1);

j = @(chromosome) ga_sys(chromosome, price);
options = optimoptions('ga', 'ConstraintTolerance',0,'MaxGenerations',10);
[U, J, exitflag] = ga(j, 9, constraint_matrix,bound_matrix,[],[],lb,ub, [],options);





