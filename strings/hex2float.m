function V = hex2float(hex)

% Brian Schlining
% 13 Sep 2000

if length(hex) ~= 16
   n = length(hex);
   buf = [];
   for i = 1:8-n
      buf = ['0' buf];
   end
   hex = [buf hex];
end

bin = hex2bin(hex);
S   = sscanf(bin(1), '%1i');
if S == 0
   sgn = 1;
else
   sgn = -1;
end

E   = bin2dec(bin(2:9));
F   = bin(10:end);

fraction = 0;
for i = 1:23
   if strcmp(F(i), '1')
      fraction = fraction + 1/(2^i);
   end
end


F = bin2dec(F);

if E == 255 & F ~= 0
   V = NaN;
elseif E == 255 and F == 0
   V = Inf;
elseif E == 0 & F == 0
   V = 0;
elseif E == 0 & F ~= 0
   V = sgn*2^(-126) * (0 + fraction);
else % if E > 0 & E < 255
   V = sgn*2^(E - 127) * (1 + fraction);
end





