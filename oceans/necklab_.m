function [w,E] = necklab_()
% NECKLAB_   -  Return Neckle and Labs exterrestrial irradiance between 333 & 709 nm
%
% Use as:  [lambda,irrad] = necklab;
%
% Inputs:  none
%
% Outputs:  lambda  = wavelength (nm)
%           irrad   = irradiance (uwatts/cm^2 nm)
% Example:  [L,E] = necklab_;plot(L,E)
%
% Ref:      Neckel, H and D. Labs. 1984. the solar radiation between 3300 and 12500 A. 
%           Solar Phys., 90:205-268.

w = [  329.80  331.80  333.80  335.90  337.90  339.80  341.90  343.80  345.80  347.90 ...
       349.80  351.90  353.90  355.90  357.90  360.00  362.00  364.10  366.10  367.80 ...
       369.80  371.90  373.70  375.50  377.50  379.40  381.40  383.40  385.40  387.40 ...
       389.40  391.20  393.20  395.00  396.90  398.90  400.10  402.00  404.00  406.00 ...
       407.90  409.90  411.70  413.70  415.60  417.60  419.10  421.10  423.10  424.80 ...
       426.80  428.60  430.60  432.60  434.00  435.90  437.20  439.20  440.90  442.80 ...
       444.70  446.40  448.30  450.30  452.40  454.40  456.40  458.40  460.40  462.40 ...
       464.40  466.40  468.40  470.40  472.30  474.30  476.30  478.30  480.30  482.30 ...
       484.30  486.30  488.30  489.30  491.30  493.30  495.10  497.10  498.90  500.90 ...
       502.90  504.90  506.80  508.80  510.80  512.80  514.80  516.80  518.80  520.00 ...
       521.90  523.90  525.80  527.80  529.80  531.60  533.50  535.40  537.20  539.20 ...
       541.00  543.00  545.00  547.00  549.00  550.80  552.70  554.70  556.70  558.70 ...
       560.70  562.70  564.60  566.60  568.60  570.60  572.60  574.60  576.60  578.50 ...
       580.50  582.50  584.50  586.50  588.40  590.40  592.30  594.30  596.30  598.30 ...
       600.30  602.30  604.30  606.30  608.00  610.00  612.00  614.00  616.00  618.00 ...
       620.00  622.00  623.90  625.90  627.90  629.90  631.90  633.90  635.90  637.90 ...
       639.90  641.90  643.90  645.90  647.90  649.90  651.90  653.90  655.90  662.10 ...
       666.30  679.00  709.00];
E = [  107.65   98.70   95.00   91.00   88.95  100.85   95.75   87.85   94.40   95.40 ...
        98.40   97.30  115.55  108.00   76.30  108.85  106.90  101.60  128.80  117.85 ...
       123.05  119.00   98.45  104.70  139.00  122.95  114.80   74.90  103.05   99.90 ...
       117.30  129.95   76.55  130.10   88.65  160.60  170.15  178.55  162.20  164.55 ...
       169.15  166.00  181.35  173.30  178.85  169.25  165.60  181.85  165.00  175.10 ...
       162.00  164.90  123.00  179.35  173.65  185.55  184.35  167.35  179.35  195.55 ...
       194.80  185.15  202.00  213.00  199.65  201.30  205.90  201.60  202.15  209.45 ...
       199.45  195.65  201.10  194.30  201.85  203.20  197.20  205.05  206.40  204.15 ...
       201.20  171.50  187.75  193.95  188.40  193.50  198.90  199.35  192.10  182.35 ...
       192.20  191.55  196.70  192.75  193.20  189.50  185.25  169.20  173.30  181.80 ...
       188.10  191.35  183.15  180.80  194.10  193.40  184.35  193.75  184.95  184.25 ...
       180.50  185.45  188.75  184.35  186.75  185.80  185.35  188.10  180.05  179.95 ...
       180.40  185.35  182.90  182.20  133.70  178.90  187.25  184.25  184.15  180.25 ...
       184.00  184.40  183.30  178.95  174.50  173.85  177.65  178.70  179.60  173.15 ...
       172.45  170.55  175.85  173.70  173.00  172.00  173.80  169.95  166.90  172.50 ...
       171.50  169.05  165.70  165.80  168.15  164.00  165.00  164.15  165.70  166.25 ...
       162.05  160.95  162.00  161.20  161.20  156.45  160.20  159.05  137.30  157.45 ...
       155.00  146.95  138.00];    

