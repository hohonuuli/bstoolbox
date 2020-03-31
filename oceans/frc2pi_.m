function P2 = frc2pi_(P1) 
% FRC2PI_ - Converts positive angle in fractions of a circle to radians 
%  
% Function used by ALMANAC_ to return positive angle  
% 
% Use As:  frc2pi_(P1) 
% 
% Input:   P1 = angle (revolutions) 
% 
% Output:  P2 = positive angle (radians) 
% 
% Example: frc2pi_(-548.2) -> 5.0265 
%          frc2pi_(8.2)    -> 1.2566 
%          frc2pi_(8.0)    -> 0 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 23 May 96; W. Broenkow 
 
P2 = 360*(P1 - floor(P1)); 
if P2 < 0 
  P2 = 360 + P2; 
end 
P2 = deg2rad_(P2); 
