function when;
fid=fopen('thisisme');
if(fid == -1)
  !whoami > thisisme;
  fid=fopen('thisisme');
  S=fscanf(fid,'%s');
  !rm thisisme
  if(strcmp(S,'beckmann'))
    disp('1945');
  elseif(strcmp(S,'woolrich'))
    disp('2003 if you are lucky');
  elseif(strcmp(S,'mark'))
    disp('Why does it matter? You will be in Australia');
  elseif(strcmp(S,'prb'))
    disp('You were rowing mate');  
  elseif(strcmp(S,'steve'))
    disp('FSL indeed - You still need MATLAB. May as well use SPM');   
  else
    disp(date)
  end
else
  disp(date)
end


