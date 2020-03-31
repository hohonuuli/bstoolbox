function testks

x = [0.6 1.2 1.6 1.7 1.7 2.1 2.8 2.9 3.0 3.2];
y = [ 2.1 2.3 3.0 3.1 3.2 3.2 3.5 3.8 4.6 7.2];
fprintf(1, 'From 101 stats\n')
%[d df p da] = kolsmirtest2(x, y)
[h, p, ksstat] = kstest2(x, y)

x = [1, 5, 38, 132, 257, 355, 399, 417, 420, 421, 421, 421, 421, 421, 421, 421, 421, 421, 421, 421, 421];
y = [0, 0, 0, 0, 1, 6, 12, 17, 33, 58, 103, 160, 247, 312, 332, 337, 342, 347, 348, 348, 349];
fprintf(1, 'From Sokal\n')
%[d df p da] = kolsmirtest2(x, y)
[h, p, ksstat] = kstest2(x, y)