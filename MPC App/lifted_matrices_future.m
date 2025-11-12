function [Psi, Theta] = lifted_matrices_future (n, H, T, Eb, avail_matrix,k)
    Psi = zeros(H*n, n);
    Theta = zeros(H*n, H*n);
    
    % Populate Psi
    for i = 1:H
        Psi(n*i-n+1:n*i,1:n) = diag(avail_matrix(:,k+i-1));
    end

    % No avail in Psi
    Psi = repmat(diag(ones(n,1)),H,1);

    % % Populate Theta 
    % for i = 1:H
    %     % Go across the columns
    %     for j = 1:i
    %         Theta(n*i-n+1:n*i,(i-j+1)*n-n+1:(i-j+1)*n) = T*diag(1./Eb)*diag(avail_matrix(:,k+j-1));
    %     end
    % end

     % Populate Theta 
    for i = 1:H
        % Go across the columns
        for j = 1:i
            % Get the matrix product
            prod = eye(n);
            for p = j:i
                prod = prod * diag(avail_matrix(:,k+p-1));
            end
            % B on the diagonal is at time i-j+1
            Theta(n*i-n+1:n*i,(i-j+1)*n-n+1:(i-j+1)*n) = prod * T*diag(1./Eb);
        end
    end

end
