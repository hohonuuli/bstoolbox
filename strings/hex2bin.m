function bin = hex2bin(hex)

% Brian Schlining
% 13 Sep 2000

n = length(hex);
bin = setstr(ones(1,n*4)*32);
hex = lower(hex);
b = 0;
for i = 1:n
   a = b + 1;
   b = a + 3;
   switch hex(i)
   case '0'
      tmp = '0000';
   case '1'
      tmp = '0001';
   case '2'
      tmp = '0010'; 
   case '3'
      tmp = '0011'; 
   case '4'
      tmp = '0100'; 
   case '5'
      tmp = '0101';
   case '6'
      tmp = '0110';
   case '7'
      tmp = '0111';
   case '8'
      tmp = '1000';
   case '9'
      tmp = '1001';
   case 'a'
      tmp = '1010';
   case 'b'
      tmp = '1011';
   case 'c'
      tmp = '1100';
   case 'd'
      tmp = '1101';
   case 'e'
      tmp = '1110';  
   case 'f'
      tmp = '1111';
   end
   bin(a:b) = tmp;
end
