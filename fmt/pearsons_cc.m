function [ ret ] = pearsons_cc( dat1,dat2,cov_mat )

if(nargin<3)
            cs = corrcoef(dat1,dat2);
            ret = cs(1,2);
else
    norma=(prod(sqrt(diag(cov_mat))));

    for its=1:100,
        x=mvnrnd([dat1'/sqrt(norma); dat2'/sqrt(norma)]',cov_mat/norma);
        
        %x1=mvnrnd([dat1/sqrt(norma)]',cov_mat(1,1)/norma); % marginal
        %x2=mvnrnd([dat2/sqrt(norma)]',cov_mat(2,2)/norma); % marginal        
        %cs = corrcoef(x1,x2);
        
        cs = corrcoef(x);
        
        cors(its)=cs(1,2);
    end;
    
    ret=mean(cors)/sqrt(var(cors)/length(its));
    

    %[gam, beta, covgam] = flame1(dat1',dat2',ones(size(dat1))*trace(cov_mat));

  %  figure;hist(cors);
  %  ret
  %  cov_mat/norma
  %  pause;
end;

end

