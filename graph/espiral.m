function espiral(Vn,D)
% ESPIRAL   - Used for demonstration graph of an Ekman spiral
% D must be a vector, not a matrix
%
% USE AS:  espiral(Vn,D)
%
% INPUTS:  Vn = Surace current velocity
%          D  = Eckman Depth

% Brian Schlining
% 17 Apr 96
% 18 Apr 96 Modified graphics

Z = linspace(0,3.*D);
[m n] = size(Z);

U      = zeros(2,n);
U(2,:) = -1*Vn*exp(-pi./D.*Z).*sin(pi./D.*Z - pi/4);

V      = zeros(2,n);
V(2,:) = -1*Vn*exp(-pi./D.*Z).*cos(pi./D.*Z - pi/4);

plot3([0 0],[0 0],[0 3.*D],'w:')
hold on
for i = 1:length(Z);
   plot3([0 U(i)],[0 V(i)],[Z(i) Z(i)],'k')
   plot3([0 U(i)],[0 V(i)],[3*D 3*D],'b')
end
H     = gca;

hold off
set(H,'zdir','reverse')
axis equal

