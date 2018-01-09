function ret = loglikelihood(data, Means, Covs, Theta)
    [N, ~] = size(data);
    [K, ~] = size(Means);
    ret = 0;
    for i=1:N
       term = 0;
       for k=1:K
           %Covs(:,:,k)
           term = term + Theta(1,k) * mvnpdf(data(i,:), Means(k,:), Covs(:,:,k));
       end
       ret = ret + log(term);
    end
end