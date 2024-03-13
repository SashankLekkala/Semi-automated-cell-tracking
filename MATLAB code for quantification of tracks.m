%CMSR Side Project Cell tracking Data analysis
clear
clc

%Import excel data
Userinput=input("Input the file name" , 's');%Insert the file name here. The xlsx file has to be in the same folder as matlab code.

Data=xlsread(Userinput); %Reads the excel sheet and stores information in matrix

partid = [Data(:,9)];  %Setting array parameters partid. (This is the array that the code is based off of)

n=length(partid); %Designating a length 

d=1; %Comparison variable 
c=1; %Column count variable
r=1; %Row count variable 

%Section the data and group into different arrays based on partid
for i=1:n
    if partid(i) == d;
        ID{r,c}= Data(i,(9:13));
        r=r+1;
    else 
        d=d+1;
        c=c+1;
        ID{1,c}=Data(i,(9:13));
        r=2;
    end
end

%Compile the matrix based on partid numbers
for c=1:length(ID(1,:))
    iso{c} = cell2mat(ID(:,c));
end

%iso will be an matrix that separates the different particles into their
%respective arrays.

%Body of the code that computes parameters in iso array
z=length(iso);
for j = 1:z;
    cell=iso{j};
    p=length(cell(:,1));
    Time=cell(:,2); %sets Time to the second column of 'cell' matrix 
    
    %converting the x/y position to pixel value.
    for i = 1:p
        x=cell(:,4);
        y=cell(:,5);
        xpixel(i)=x(i);
        ypixel(i)=y(i);
    end 
    
    %portion of the code that compiles dx,dy, euclidean, speed values
    for i = 1:(p-1);
        dx(i)=xpixel(i+1)-xpixel(i);
        dy(i)=ypixel(i+1)-ypixel(i);
        euclidean(i)=sqrt((dx(i)^2)+(dy(i)^2));
        speed(i)=euclidean(i)/(Time(i+1)-Time(i));
    end
    meanspd=mean(speed);
    totaldistance=sum(euclidean);
    xdisplacement= xpixel(p)-xpixel(1);
    ydisplacement= ypixel(1)-ypixel(p);
    %Directionality if statement comparisons 
    if (xdisplacement > 0) & (ydisplacement > 0);
        theta=abs(atan(ydisplacement/xdisplacement));
        directionality=((theta)*(180/pi));
    elseif (xdisplacement < 0) & (ydisplacement > 0);
        theta=abs(atan(ydisplacement/xdisplacement));
        directionality= (180-((180/pi)*theta));
    elseif (xdisplacement < 0) & (ydisplacement <= 0);
        theta=abs(atan(ydisplacement/xdisplacement));
        directionality= (180+((180/pi)*theta));
    elseif (xdisplacement > 0) & (ydisplacement <= 0);
        theta=abs(atan(ydisplacement/xdisplacement));
        directionality= (360-((180/pi)*theta));
    elseif (xdisplacement == 0) & (ydisplacement > 0);
        theta=90;
        directionality = theta;
    elseif (xdisplacement == 0) & (ydisplacement < 0);
        theta=270;
        directionality = theta;
    elseif (xdisplacement == 0) & (ydisplacement ==0);
        directionality = 999;
    end
    %Storing information in new matrix columns 
    iso{j}(:,6)=xpixel;
    iso{j}(:,7)=ypixel;
    iso{j}(2:p,8)=dx;
    iso{j}(2:p,9)=dy;
    iso{j}(1,10)= sqrt((ydisplacement^2)+(xdisplacement^2));
    iso{j}(1,11)= (sqrt((ydisplacement^2)+(xdisplacement^2))/(p-1));
    iso{j}(1,12)= totaldistance;
    iso{j}(1,13)= (totaldistance/(p-1));
    iso{j}(1,14)= xdisplacement;
    iso{j}(1,15)= ydisplacement;
    iso{j}(1,16)= directionality;
    iso{j}(1,17)= xpixel(1)
    iso{j}(1,18)= ypixel(p)
    
    clear xpixel ypixel dx dy euclidean speed p directionality 
end


%Combining arrays that were previously separated. 
final=cat(1,iso{1:(j)});


%Array of excel titles
titles= ["partid"; "nspot"; "time";"xpos";"ypos";"xpixel";"ypixel";"dx";"dy"; "total displacement";"displacement";"total distance"; ...
    "mean speed";"xdisplacement";"ydisplacement";"directionality"; "initial x position"; "initial y position"]';

%Combining array titles with matrix of data


finalt=final(:,[1:2 10:18]);

str2double(finalt);

ind= find((finalt(:,5)==0));
finalt(ind, :) = [];

titles1= ["partid"; "nspot" ; "total displacement";"velocity";"total distance"; ...
    "speed";"xdisplacement";"ydisplacement";"directionality";"initial x position"; "initial y position"]';

final1=cat(1,titles1,finalt);
final=cat(1,titles,final);
%Writes the final calculations and terms into the second sheet of the excel
%file.
%Excel sheet has to have a second and third sheet for this function to work.

writematrix(final,Userinput,'Sheet',2);
writematrix(final1,Userinput,'Sheet',3);






