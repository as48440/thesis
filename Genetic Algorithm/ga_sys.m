function total_cost = ga_sys(chromosome, price)

    % Simulation Parameters
    n = 1;                          % Number of vehicles in the simulation 
    T = 1/12; 
    Nsim = 288*1;                   % 288 samples = 1 day 
    Eb = 60;                        % kWh - Tesla Model Y
    Cb = 150 * Eb;
    lambda = 5000 * Eb;
    FLC = create_fis(chromosome);

    x =zeros(n,Nsim);                      % Array of SoC
    u =zeros(n,Nsim);                      % Array of control power inputs
    x(:,1) = 0.7*ones(n,1);                % Initial SoC

    total_cost = 0;

    for k = 1:Nsim
        for v = 1:n
            warning('off','all');
            u(v,k) = evalfis(FLC,[price(k),x(v,k)]);
        end 
        x(:,k+1) = x(:,k) + T/Eb*u(:,k);
        total_cost = total_cost + sum(u(:,k))*price(k)*1/12*1/1000+ T*abs(u(:,k))*Cb/lambda;
    end
end 