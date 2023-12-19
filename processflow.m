struct1(1).a=[1,2,3];
struct1(1).b=[2,2,2];

struct1(2).c=struct1(1).a.*struct1(1).b;
% put the results of dot multiply of row1, field a times row 1 field b in 
% row two, field c 

disp(struct2table(struct1))

% do some additional math and data movement 
struct1=doproc1(struct1); % first process (like your first reactor)
disp(struct2table(struct1))

struct1=doproc2(struct1); % second process like your second reactor
% if they are in series, etc 
disp(struct2table(struct1))

function struct1=doproc1(struct1)
n1=size(struct1);
n1=n1(2); 
n1=n1+1 ; % for the next row
struct1(n1).c=struct1(n1-1).c;
struct1(n1).d=struct1(n1-1).c.^2;
end

function struct1=doproc2(struct1)
n1=size(struct1);
n1=n1(2); 
n1=n1+1 ; % for the next row
struct1(n1).d=struct1(n1-1).d;
struct1(n1).e=struct1(n1-1).d.^2;
struct1(n1).f={"I'm stopping now"}
end