function barwhisker(mn,err)

bar(mn,'k');
ho;
ind=1:length(mn);
line([ind; ind],[mn; mn+err],'LineWidth',3,'Color','k');
line([ind-0.1; ind+0.1],[mn+err; mn+err],'LineWidth',3,'Color','k');