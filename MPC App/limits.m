function [Omega, w] = limits(Psi, Theta,n, x, H, avail_matrix,k)
    % Form lower SoC constraint based on time - raise SoC between 2-8am

    SoC_range = linspace(0,0.6,13);
    if (mod(k,48)>= 2*2 && mod(k,48) <= 8*2)
        arr = -[SoC_range((mod(k,48)-3):13) zeros(1,(mod(k,48)-4))]';
        
        % Trunc to ctrl horizon
        if (length(arr) > H)
            arr = arr(1:H);
        else
            arr = [arr; zeros(H-length(arr),1)];
        end

        arr = repelem(arr,n,1);

        % Check availability 
        avail = avail_matrix(:,k);
        for j = 1:n:(H-1)*n
            arr(j:j+n-1) = arr(j:j+n-1).*avail;
        end

        Xm = [arr;ones(H*n,1)];
    else 
        Xm = [zeros(H*n,1);ones(H*n,1)];
    end
    Um = repmat(12*avail_matrix(:,k), 2*H,1);

    Omega1 = [-eye(H*n); eye(H*n)];
    Omega2 = [-eye(H*n); eye(H*n)];

    Omega = [Omega1; Omega2 * Theta];
    w = [Um; Xm - Omega2 * Psi * x];
    
end 