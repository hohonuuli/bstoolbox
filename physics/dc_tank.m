function C = dc_tank(Ci,Ri,Co,V,T)
% DC_TANK   - Calculate Concentration of a fluid in a tank
% 
% use as:  dc_tank(Ci,Ri,Co,V,T)
%	          
%	        Ci = Concentration of in-flow
%	 	Ri = Flow rate
%		Co = Initial resivoir concentration
%		V  = Volume of the resivoir
%		T  = time
%
% Assumptions:
%	DC_TANK calculates the concentration in a tank with volume, V, and 
% 	initial concentration, Co, considering an input with 
%       a flow rate, Ri, and concentration, Ci. The outflow has a flow rate 
%	equal to the in-flow, Ri and concentration equal to the current tank 
%	concentration. (i.e. It assumes perfect mixing)

% B. Schlining
% for fun on 11 Mar 96. Developed from first principals
% Ci = 0.1; Ri = 1; Co = 10; V = 100; T = 1:1000;

C = Ci - (Ci - Co) * exp(-Ri.*T./V);
