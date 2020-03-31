function n = normalize(d)
% NORMALIZE - Normalize a matrix so that it sums to 1 
%
% Usage:
%   n = normalize(d)
%
% Inputs:
%   d = A matrix (Note: if it contains NaN or Inf you will get NaN or Inf as a result)
%   
% Outputs:
%   n = The matrix normalized so that all values sum to 1. 

% Brian Schlining
% 2012-06-04

t = sum(d(:));

n = d ./ t;
