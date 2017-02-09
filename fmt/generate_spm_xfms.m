% Generates a t2_spm_rot0.xfm file for each directory, by
%  converting the t2_spm_rot0.m file into medx format

init_size=[256 256 30];
final_size=[172 220 156];
cd /usr/people/steve/reg/stroke_stpendle
dirs=str2mat('ab980121sk.Ly1','ag050398.Mf1','ag120897sk.Mm2');
dirs=str2mat(dirs,'ag220498sk.N11','at980108sk.Ll1','bd900113s.Lq1');
dirs=str2mat(dirs,'cd030498.MI1','dg230697sk.I71','dw160697sk.I01');
dirs=str2mat(dirs,'dy190697sk.I31','jm980212_s.LU1','kd040398sk.Me1');
dirs=str2mat(dirs,'mc120697sk.HW1','nb300697sk.Ie1','ps190298sk.M11');
dirs=str2mat(dirs,'rb120697sk.HW1','sf040298sk.MH1','wp260298sk.M81');
for n=1:length(dirs(:,1)),
  eval(['cd ',dirs(n,:)]);
  sxfm=get_trans('t2_spm_rot0.m');
  mxfm=spm2medx(sxfm,init_size,final_size);
  write_medx_xfm('t2_spm_rot0.xfm',final_size,[],mxfm,[]);
  cd ..
end
