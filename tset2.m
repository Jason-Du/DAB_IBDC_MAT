% A=2.8*ones(4,1);
% B=4.2*ones(100,1);
% C=cat(1,A,B);
a=[4 3 1 2 10 11 5 7];
b=[1 3 10 21 6 6 3 7];
ismember(a(:,1),b(:,1))
[val,pos]=intersect(a,b)