function [codedMvs] = codeMotionVectors(Mvs)
%CODEMOTIONVECTORS Entropy coding of motion vectors.
%   Run length encoding

codedMvs = cell(1,2);
codedMvs{1} = runlengthenc(Mvs(1,:)); %run length encode x's
codedMvs{2} = runlengthenc(Mvs(2,:)); %run length encode y's

end

