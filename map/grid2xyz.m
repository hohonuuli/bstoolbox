function [x, y, z] = grid2xyz(gridfile, xyzfile)

[X, Y, Z] = readArcRaster(gridfile);

[i, j] = size(Z);
x = ones(i * j, 1);
y = ones(i * j, 1);

for ix = 1:length(X)
    for iy = 1:length(Y)
        x(i) = X(ix);
        y(i) = Y(iy);
        z(i) = Z(iy, ix);
    end
end

%fid = fopen(xyzfile, 'rt');
for i = 1:length(z)
   fprintf (1, '%10.5f, %10.5f, %10.5f\n', x(i), y(i), z(i));
end