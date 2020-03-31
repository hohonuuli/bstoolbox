function hodograph1(U, V, varargin)
% HODOGRAPH1 - Create a hodograph from U and V velocities
%
% Use as: hodograph1(U, V)
%         hodograph1(U, V, lineStyle)
%         hodograph1(U, V, Z)
%         hodograph1(U, V, Z, lineStyle)
%         hodograph1(U, V, Z, zLabel)
%         hodograph1(U, V, Z, zLabel, lineStyle)

% Brian Schlining
% 14 May 2001

args = varargin;

lineStyle = 'b-';
Z = [];
zLabel = [];

if length(args) >= 1
    if isstr(args{1})
        lineStyle = args{1};
    else
        Z = args{1};
    end
end

if length(args) >= 2
    if isstr(args{1})
        lineStyle = args{2};
    else
        zLabel = args{2};
    end
end

if length(args) == 3
    lineStyle = args{3};
end

Angl = mth2geo_(rad2deg_(atan2(U, V)));
Disp = sqrt(U.^2 + V.^2);

h1 = polargeo(Angl, Disp, lineStyle);

if ~isempty(zLabel)
    hold on
    n = 0;
    good = [];
    for i = 1:length(zLabel)
        buf = min(find(Z == zLabel(i)));
        if ~isempty(buf)
            n = n + 1;
            good(n) = buf;
        end
            
    end
    Color = get(h1, 'Color');
    h2 = polargeo(Angl(good), Disp(good), 'k.');
    set(h2, 'Color', Color)
    [X Y] = pol2cart(deg2rad(geo2mth_(Angl(good))), Disp(good));
    tH = text(X,Y,num2str(ceil(Z(good))),'FontSize',8);
    set(tH,'HorizontalAlignment','right', 'Color', Color)
    hold off
    
end

