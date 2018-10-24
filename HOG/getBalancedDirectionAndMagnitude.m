function [valueInf, valueSup] = getBalancedDirectionAndMagnitude(inf,sup,direction,magnitude)
    A = sup - direction;
    B = direction - inf;
    A = ((A*100)/20)/100;
    B = ((B*100)/20)/100;
    valueInf = A*magnitude;
    valueSup = B*magnitude;
end


