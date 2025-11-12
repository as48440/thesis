function [Psi, Theta] = lifted_matrices(n, H, T, Eb, avail_matrix,k)
    Psi = zeros(H*n, n);
    Theta = zeros(H*n, H*n);

    % Populate Psi
    Psi = repmat(diag(avail_matrix(:,k)),H,1);

    % No avail in Psi
    Psi = repmat(diag(ones(n,1)),H,1);

    % Populate Theta 
    for i = 1:H     % down the rows
        for j = 1:i % across the columns
            Theta(n*i-n+1:n*i,(i-j+1)*n-n+1:(i-j+1)*n) = T*diag(1./Eb)*diag(avail_matrix(:,k));
        end
    end
end
