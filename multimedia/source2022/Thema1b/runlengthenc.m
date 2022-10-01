function [enc] = runlengthenc(seq)
%RUNLENGTH Perform runlength encoding
%   Detailed explanation goes here

c=1;
enc=[];
for i=1:length(seq)-1
    if(seq(i)==seq(i+1))    %if same symbol
        c=c+1;  %increment counter
    else
        enc=[enc,c,seq(i),];  %else add symbol count and symbol
    c=1;    %and reset counter
    end
end
enc=[enc,c,seq(length(seq))];

end