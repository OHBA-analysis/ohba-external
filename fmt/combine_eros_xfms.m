% Combines the various transformation files associated with the EROS
%  corrected AIR transforms
%
% It takes the resampling from E0.xfm, the eros transform from E.xfm
%  and the AIR transform from E2.xfm
% The output transformation is written as a shadow transformation in
%  Eros.xfm

cd /usr/people/steve/reg/stroke_stpendle
dirs=str2mat('ab980121sk.Ly1','ag050398.Mf1','ag120897sk.Mm2');
dirs=str2mat(dirs,'ag220498sk.N11','at980108sk.Ll1','bd900113s.Lq1');
dirs=str2mat(dirs,'cd030498.MI1','dg230697sk.I71','dw160697sk.I01');
dirs=str2mat(dirs,'dy190697sk.I31','jm980212_s.LU1','kd040398sk.Me1');
dirs=str2mat(dirs,'mc120697sk.HW1','nb300697sk.Ie1','ps190298sk.M11');
dirs=str2mat(dirs,'rb120697sk.HW1','sf040298sk.MH1','wp260298sk.M81');
for n=1:length(dirs(:,1)),
  eval(['cd ',dirs(n,:)]);
  [t1,dum1,dum2]=read_medx_xfm('E0.xfm');
  [t2,dum1,dum2]=read_medx_xfm('E.xfm');
  [dum1,t3,dum2]=read_medx_xfm('E2.xfm');
  t_total=t3*t2*t1;
  write_medx_xfm('Eros.xfm',[172 220 156],[],t_total,[]);
  cd ..
end
