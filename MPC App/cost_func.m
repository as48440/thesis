function cost = cost_func(U,f,g)
    cost = sum(U.*f + abs(U).*g);
end

