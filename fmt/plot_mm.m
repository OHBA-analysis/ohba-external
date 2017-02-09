function plot_mm(mix,data,mm)

% plot_mm(mix,data)
% 
% plots Gaussian Mixture Model compared with data

nmixes = length(mix.centres);
res = (percentile(data,100) - percentile(data,0))/(length(data)/40);

mind = res*floor(min(data)/res);
maxd = res*ceil(max(data)/res);
minsubd = res*floor((min(data)-3*max(data))/res);
al = [mind:res:maxd]';
alneg = [mind:res:-res]';
alplus = [res:res:maxd]';
alsubneg = [minsubd:res:minsubd+(length(al)-1)*res]';
size(al)
size(alsubneg)

mixtures = zeros(nmixes,length(al));

hs = hist(data,al);
hand = bar(al,hs/sum(hs));
set(hand,'EdgeColor',[0.6 0.6 0.6]);
set(hand,'FaceColor',[0.6 0.6 0.6]);
%colormap('gray');
a = axis;
axis([percentile(data,0),percentile(data,100),a(3),a(4)]);
hold on;

maxdata=max(data);

for m=1:nmixes,
  if mix.priors(m) > 0,

    if((mm == 2 | mm == 3) & m==3)      
      me=mix.centres(m);
      va=mix.covars(m);
      plus = mix.priors(m)*gammapdf(me^2/va, me/va, alplus)';
      mixtures(m,length(al)-length(alplus)+1:length(al)) = plus; 
      
    elseif((mm == 2 | mm == 3) & m==1)
      me=-mix.centres(m);
      va=mix.covars(m);      
      neg = mix.priors(m)*gammapdf(me^2/va, me/va, -alneg)';
      mixtures(m,1:length(alneg)) = neg;      
 
    elseif(mm == 3 & m==2)
			
      me=-(mix.centres(m)-3*maxdata);
      va=mix.covars(m);      
      neg = mix.priors(m)*gammapdf(me^2/va, me/va, -alsubneg)';
      mixtures(m,1:length(alsubneg)) = neg;      
     
    elseif(mix.covars(m)>0)
	
      mixtures(m,:) = mix.priors(m)*normpdf(al,mix.centres(m),sqrt(mix.covars(m)))';    
    end;

  end;
end;

for m=1:nmixes,
   
  %plot(al',mix.priors(m)*mixtures(m,:)./sum(sum(mixtures,2)),'r','LineWidth',2);
  plot(al',mixtures(m,:)./sum(sum(mixtures,2)),'k--','LineWidth',2.5);
end;

plot(al',sum(mixtures,1)./sum(sum(mixtures,2)),'k','LineWidth',2.5);

hold off;
