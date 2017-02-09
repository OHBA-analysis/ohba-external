function plot_and_hist(x,a,b,n);
%  PLOT_AND_HIST(X,A,B,N);
%  X is x-axis for plot. N is number of bins of histogram;
%
%  PLOT_AND_HIST(X,A,B)
%  X is also X-axis for hist.
%  A gets plotted B gets histogrammed. they are normalised
%  to match. For checking distributions
%  TB

An=a/sum(a);
bwpl=abs(x(5)-x(4));
if(nargin>3)
  [N,X]=hist(b,n);
  bw=abs(X(5)-X(4));
  bar(X,N/sum(N)*bwpl/bw);
else
  N=hist(b,x);
  An=a/sum(a(2:length(a)-2));
  bar(x,N/sum(N(2:length(N)-2)));
end
hold on;
%plot(x,An,'LineWidth',2,'LineStyle','-.','Color','c');
plot(x,An,'LineWidth',2,'LineStyle','-','Color','c');
hold off
