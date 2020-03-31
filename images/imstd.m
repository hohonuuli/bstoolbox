function outimg = imstd(img, n)

[r c] = size(img);
outimg = ones(r, c);
for i = n:(r - n)
    for j = n:(c - n)
        buf = img(i:(i + n), j:(j + n));
        outimg(i, j) = std(buf(:));
    end
end
