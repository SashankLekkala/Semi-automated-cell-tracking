%% CMSR Cell Tracking Contact Time 

clear
clc

Data=xlsread("Copy of C1-Mouse 95, 2hr_Tracks.xlsx", "Sheet1"); 
Data1=xlsread("Copy of C2-Mouse95,2hr_Tracks.xlsx", "Sheet1");

partid = [Data(:,1)];
partid1 = [Data1(:,1)];

d=1; %Comparison variable 
c=1; %Column count variable
r=1; %Row count variable 

n=length(partid);

for i=1:n
    if partid(i) == d;
        ID{r,c}= Data(i,(1:5));
        r=r+1;
    else 
        d=d+1;
        c=c+1;
        ID{1,c}=Data(i,(1:5));
        r=2;
    end
end

for c=1:length(ID(1,:))
    iso{c} = cell2mat(ID(:,c));
end

j=length(partid1);
d1=1; %Comparison variable 
c1=1; %Column count variable
r1=1; %Row count variable 

for i=1:j
    if partid1(i) == d1;
        ID1{r1,c1}= Data1(i,(1:5));
        r1=r1+1;
    else 
        d1=d1+1;
        c1=c1+1;
        ID1{1,c1}=Data1(i,(1:5));
        r1=2;
    end
end

for c1=1:length(ID1(1,:))
    iso1{c1} = cell2mat(ID1(:,c1));
end

p=length(iso);
n=length(iso1);
for m = 1:p;
    cell=iso{m};
    xy=cell(:,4:5);
    time= cell(:,3);
    for i= 1:n;
        cell1=iso1{i};
        xy1=cell1(:,4:5);
        time1= cell1(:,3);
        o=length(xy);
        l=length(xy1);
        count=0;
        for k= 1:o;
            comp=[xy(k,1),xy(k,2)];
            comptime=time(k);
            for c = 1:l;
                comp1=[xy1(c,1),xy1(c,2)];
                comptime1=time1(c);
                if abs(comptime-comptime1) == 0;
                    dy=(xy1(c,2))-(xy(k,2));
                    dx=(xy1(c,1))-(xy(k,1));
                    if sqrt((dy^2)+(dx^2)) <= 10.5;
                    count= count + 1;
                    else
                    count=count;
                    end
                end
            end
                if count ~=0;
                iso{m}(c,6)=iso1{i}(1,1);
                iso{m}(c,7)=count; 
                end
            %if length(iso{m}(1,:))==7;
            %Find a way to automatically save relevant data
        end
    end
end







