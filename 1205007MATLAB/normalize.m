function ret = normalize(Array)
    sum = 0;    
    [~, col] = size(Array);
    
    for i=1:col
        sum = sum + Array(i);
    end
    
    for i=1:col
        Array(i) = Array(i) / sum;
    end
    
    ret = Array;
end