function out = chopstruct(in, indices)
% CHOPSTRUCT - Removes parts of vectorized structures
%
% Use as: out = chopstruct(in, indices);
% 
% Inputs: in = structure
%         indices = indices of structure variables to keep
%
% Output: out = edited structure
%
% Example: in.name = {'boy','girl','bad','cat','dog'};
%          in.age  = [11 12 NaN 3 6];
%          out = chopstruct(in, [1 2 4 5])

% Brian Schlining
% 05 jan 2000

out = [];
fn = fieldnames(in);
for i = 1:length(fn)
   out = setfield(out, fn{i}, getfield(in, fn{i}, {indices}));
end
