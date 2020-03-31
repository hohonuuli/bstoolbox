function plot_sanctuary(pstr,lwidth);
load MBNMS_latlon.mat
p=plot(Slon,Slat,'k'); set(p,'linewidth',lwidth,'color',pstr);
