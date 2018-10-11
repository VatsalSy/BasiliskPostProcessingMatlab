%% Draw and save Facets!
% Author: Vatsal Sanjay
% vatsalsanjay@gmail.com
% Physics of Fluids
%%
clc
clear
close
%% Output Folder
tN = 31;
folder = 'interface'; % output folder
opFolder = fullfile(cd, folder);
if ~exist(opFolder, 'dir')
mkdir(opFolder);
end
%% Code to extract facet and save interface
counter=0;
Interface=struct([]);
InterfaceC=struct([]);

LEVEL = 10;
Ldomain = 16;
xmin = -2;
xmax = 2;
ymin = 0.0;
ymax = 2;
nx = 2^(LEVEL);
ny = 2^(LEVEL);

for ti = 0:1:tN
    tic
    counter = counter+1;
    t = ti*0.1;
    place = sprintf('intermediate/snapshot-%5.4f',t);
    
    %% Getting all the interface locations using facet function of Basilisk C
    ll=evalc(sprintf('!./getFacet %s %s', place, num2str(1)));
    lolo=textscan(ll,'%f %f\n');
    xf1=lolo{1}; yf1=lolo{2};
    Interface{counter}{1} = xf1; Interface{counter}{2} = yf1; 
    ll=evalc(sprintf('!./getFacet %s %s', place, num2str(2)));
    lolo=textscan(ll,'%f %f\n');
    xf2=lolo{1}; yf2=lolo{2};
    Interface{counter}{3} = xf2; Interface{counter}{4} = yf2; 
    ll=evalc(sprintf('!./getFacet %s %s', place, num2str(3)));
    lolo=textscan(ll,'%f %f\n');
    xf3=lolo{1}; yf3=lolo{2};
    Interface{counter}{5} = xf3; Interface{counter}{6} = yf3;
    
    %% Getting all the interface locations by plotting contours
    [X, Y, f1, f2, f3] = getData(place, xmin, xmax, ymin, ymax, nx, ny);
    figure0 = figure('visible','off','WindowState','fullscreen','Color',[1 1 1]);
    [c1,~] = contour(X,Y,f1,1);
    hold on
    [c2,~] = contour(X,Y,f2,1);
    [c3,~] = contour(X,Y,f3,1);
    xs1 = c1(1,2:c1(2,1)+1); ys1 = c1(2,2:c1(2,1)+1);
    InterfaceC{counter}{1} = xs1; InterfaceC{counter}{2} = ys1;
    xs2 = c2(1,2:c2(2,1)+1);
    ys2 = c2(2,2:c2(2,1)+1);
    InterfaceC{counter}{3} = xs2; InterfaceC{counter}{4} = ys2;
    xs3 = c3(1,2:c3(2,1)+1);
    ys3 = c3(2,2:c3(2,1)+1); 
    InterfaceC{counter}{5} = xs3; InterfaceC{counter}{6} = ys3;
    close all
    
    %% Facets <Draw>
    count = 0;
    TYPE = struct([]); TYPE{1} = 'r.'; TYPE{2} = 'b.'; TYPE{3} = 'g.';
    TYPEC = struct([]); TYPEC{1} = 'r-'; TYPEC{2} = 'b-'; TYPEC{3} = 'g-';
    close all
    figure1 = figure('visible','off','WindowState','fullscreen','Color',[1 1 1]);
    subplotTemp = struct([]);
    for i = 1:1:4
        subplotTemp{i} = subplot(2,2,i,'Parent',figure1);
        count = count + 2; 
        if (i ~= 4)
            for k = 1:2:length(Interface{counter}{count-1})
                plot(Interface{counter}{count-1}(k:k+1),Interface{counter}{count}(k:k+1),TYPE{i},'Parent',subplotTemp{i},'MarkerSize',15)
                hold on
            end
            plot(InterfaceC{counter}{count-1},InterfaceC{counter}{count},TYPEC{i},'Parent',subplotTemp{i},'linewidth',3)
        else
            % here we try to plot the coordinated of 1 (drop: red) before
            % the others
            typeCounter = 1;
            for p = 1:2:5
                for k = 1:2:length(Interface{counter}{6-p})
                    plot(Interface{counter}{6-p}(k:k+1),Interface{counter}{6-p+1}(k:k+1),TYPE{4-typeCounter},'MarkerSize',15,'Parent',subplotTemp{i})
                    hold on
                end
                plot(InterfaceC{counter}{6-p},InterfaceC{counter}{6-p+1},TYPEC{4-typeCounter},'Parent',subplotTemp{i},'linewidth',3)
                typeCounter = typeCounter + 1;
            end
        end
        box(subplotTemp{i},'on');
        set(subplotTemp{i},'FontName','times new roman','FontSize',15,'FontWeight','bold',...
            'LineWidth',2);
        axis equal
        xlim(subplotTemp{i}, [-1.25 1.25])
        ylim(subplotTemp{i}, [0 1])
        xlabel('\boldmath{$X/D$}','LineWidth',2,'FontWeight','bold','FontSize',20,...
            'FontName','times new roman',...
            'Interpreter','latex');
        ylabel('\boldmath{$Y/D$}','LineWidth',2,'FontWeight','bold','FontSize',20,...
            'FontName','times new roman',...
            'Interpreter','latex'); 
    end
    set(figure1,'pos',[1 1 900 450]);
    image = [folder '/' sprintf('%6.6d',ti)];
    print(image,'-dpng','-r300')
    close all
    toc
    fprintf('%d of %d\n',ti+1, tN+1);
end
Description = 'Interface{time}{i} - 1 is xf1, 3 is xf2 and 5 is xf3. Corresponding y';
DescriptionC = 'InterfaceC{time}{i} - is same as Interface{}{} except being extracted from contours of f_j';
save('Interface.mat','Interface','Description','InterfaceC','DescriptionC')
clear
load('Interface.mat')
