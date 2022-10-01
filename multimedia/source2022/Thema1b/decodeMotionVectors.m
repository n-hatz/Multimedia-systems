function [mvs] = decodeMotionVectors(coded_mvs)
%DECODEMOTIONVECTORS decodes RL-encoded motion vectors
%   Detailed explanation goes here
mvs(1,:) = runlengthdec(coded_mvs{1});  %run length decode x's
mvs(2,:) = runlengthdec(coded_mvs{2});  %run length decode y's
end

