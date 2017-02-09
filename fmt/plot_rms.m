function plot_rms(res)
% plot_rms(res)

clf
imno=1:1/6:(19-1/6);
hold on                   
axis([0 20 0 25])
for l=1:19,
  plot([l,l],[0 140],':');   
end
box on
set(gca,'FontSize',14);
xlabel('Image Number')
ylabel('RMS Deviation (mm)')
%title('FLIRT - Consistency Study')
h=gca;
set(h,'XTick',(1:18))
plot(imno,res(:,7),'-o')
