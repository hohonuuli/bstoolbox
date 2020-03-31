% dmerid.m
% Interesting thing about meridional parts when changing latitude by .i degrees
% 5 Aug 96
l = 90;
i = 1:15;
l = l - 10.^(-i);
d(1,i) = meridin1(l)./meridin1(90);
format short;
d = diff(d)


