
% BorderLength-----
% NodeAmount-------
% BeaconAmount---
% Sxy--------------
%Beacon----------BeaconAmount*BeaconAmount 
%UN-------------2*UNAmount 
% Distance------;2*BeaconAmount 
%h--------------- 
%X---------------,X=[x,y]' 
% R------------------10-100m 
function Accuracy =DVc(NodeAmount,BeaconAmount,R,kk) 
BorderLength=100; 
UNAmount=NodeAmount-BeaconAmount; 
% D=zeros(NodeAmount,NodeAmount);
h=zeros(NodeAmount,NodeAmount);
X=zeros(2,UNAmount);

C=BorderLength.*rand(2,NodeAmount); 
%?????????????? 
Sxy=[[1:NodeAmount];C]; 
Beacon=[Sxy(2,1:BeaconAmount);Sxy(3,1:BeaconAmount)];
UN=[Sxy(2,(BeaconAmount+1):NodeAmount);Sxy(3,(BeaconAmount+1):NodeAmount)];

figure(2)
 plot(Sxy(2,1:BeaconAmount),Sxy(3,1:BeaconAmount),'r*',Sxy(2,(BeaconAmount+1):NodeAmount),Sxy(3,(BeaconAmount+1):NodeAmount),'k.') 
 xlim([0,BorderLength]); 
 ylim([0,BorderLength]); 
 title('* ???????? . ???δ????') 

for i=1:NodeAmount 
    for j=1:NodeAmount 
        Dall(i,j)=((Sxy(2,i)-Sxy(2,j))^2+(Sxy(3,i)-Sxy(3,j))^2)^0.5;
        if (Dall(i,j)<=R)&(Dall(i,j)>0) 
            h(i,j)=1;
        elseif i==j 
            h(i,j)=0; 
        else h(i,j)=inf; 
        end 
    end 
end 

for k=1:NodeAmount 
    for i=1:NodeAmount 
        for j=1:NodeAmount 
            if h(i,k)+h(k,j)<h(i,j)%min(h(i,j),h(i,k)+h(k,j)) 
                h(i,j)=h(i,k)+h(k,j); 
            end 
        end 
    end 
end 
h; 

h1=h(1:BeaconAmount,1:BeaconAmount);  
D1=Dall(1:BeaconAmount,1:BeaconAmount); 
for i=1:BeaconAmount 
    dhop(i,1)=sum(D1(i,:))/sum(h1(i,:));
end 
% D2=Dall(1:BeaconAmount,(BeaconAmount+1):NodeAmount);%BeaconAmount??UNAmount?? 
h2=h(1:BeaconAmount,(BeaconAmount+1):NodeAmount);%BeaconAmount??UNAmoun t?? 
for i=1:BeaconAmount 
    for j=1:UNAmount 
        if min(h2(:,j))==h2(i,j) 
            Dhop(1,j)=dhop(i,1);
        end 
    end 
end 
cc=mean(dhop); 

err_dis=zeros(BeaconAmount,1); 
for i=1:BeaconAmount 
    for j=1:BeaconAmount 
        if i~=j 
            err_dis(i)=err_dis(i)+abs((Dall(i,j)-cc*h(i,j))/h(i,j)/(BeaconAmount-1)); 
        end 
    end 
end 
c_err_dis=mean(err_dis); 
new_cc=cc+kk*c_err_dis; 

hop1=h(1:BeaconAmount,(BeaconAmount+1):NodeAmount); 
for i=1:UNAmount 

  hop=new_cc; 
    Distance(:,i)=hop*hop1(:,i);
end 

d=Distance; 
for i=1:2 
    for j=1:(BeaconAmount-1) 
      a(i,j)=Beacon(i,j)-Beacon(i,BeaconAmount); 
    end 
end 
A=-2*(a'); 
% d=d1'; 
 for m=1:UNAmount  
     for i=1:(BeaconAmount-1) 
         B(i,1)=d(i,m)^2-d(BeaconAmount,m)^2-Beacon(1,i)^2+Beacon(1,BeaconAmount)^2-Beacon(2,i)^2+Beacon(2,BeaconAmount)^2; 
     end 
           X1=inv(A'*A)*A'*B; 
           X(1,m)=X1(1,1); 
           X(2,m)=X1(2,1); 
 end 
 for i=1:UNAmount 
     error(1,i)=(((X(1,i)-UN(1,i))^2+(X(2,i)-UN(2,i))^2)^0.5); 
 end 


 error=sum(error)/UNAmount; 
 Accuracy=error/R; 
end
