function [dec] = runlengthdec(sequence)
%RUNLENGTHDEC Summary of this function goes here
%   Detailed explanation goes here
c=[];
for i=1:2:length(sequence)
    c=[c sequence(i)]; %save counts
end
s=[];
for i=2:2:length(sequence)
    s=[s sequence(i)]; %save symbols
end
dec=[];
for i=1:length(c)
    cc=c(i); %count
    cs=s(i); %symbol
    for j=1:cc
        dec=[dec cs];    %add "count" times the symbol
    end
end
end
