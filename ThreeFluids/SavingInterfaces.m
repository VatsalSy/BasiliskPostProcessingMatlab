%%
% Author: Vatsal Sanjay
% vatsalsanjay@gmail.com
% Physics of Fluids
%% Gerris data to uniform data in TriplePoint.mat & TriplePoint.fig
clc
clear
close all
%% Output Folder
folder = 'interface'; % output folder
opFolder = fullfile(cd, folder);
if ~exist(opFolder, 'dir')
mkdir(opFolder);
end
%% Saving the Mesh
nGFS = 200;
R = 1e-3;
Ldomain = 8*R;
xmin = -4*R;
xmax = 4*R;
ymin = 0.000*Ldomain;
ymax = 4*R;
nx = 1024;
ny = 1024;
x = linspace(xmin, xmax, nx);
y = linspace(ymin, ymax, ny);
tic
gridfile='cartgridMatlab.dat';
disp('saving the 2d grid');
[X,Y,Z] = meshgrid(x,y,0);
loc=[X(:),Y(:),Z(:)];
save(gridfile,'loc','-ASCII','-SINGLE');
toc
Interface=struct([]);
time = zeros(nGFS,1);
radius = zeros(nGFS,1);
for ti = 0:1:nGFS
    t = ti*0.0002;
    place = sprintf('intermediate/sim%5.4f.gfs',t);
    if ~exist(place,'file')
        disp('%file does not exist!..............................')
        disp(place)
    else
        image = [folder '/' sprintf('%6.6d.png',ti)];
        close all
        f1 = structuredData(place, gridfile, X, Y,'f1');
        f2 = structuredData(place, gridfile, X, Y,'f2');
        figure1 = figure('visible','off','InvertHardcopy','off','Color',[1 1 1]);
        axes1 = axes('Parent',figure1);
        hold(axes1,'on');
        [c1,~] = contour(X/R,Y/R,f1,1,'b-','LineWidth',3);
        [c2,~] = contour(X/R,Y/R,f2,1,'r-','LineWidth',3);
        ylabel('\textbf{Y/R}','FontSize',35,'Interpreter','latex');
        xlabel('\textbf{X/R}','FontSize',35,'Interpreter','latex');
        box(axes1,'on');
        axis equal
        set(axes1,'BoxStyle','full','FontName','times new roman','FontSize',25,...
            'FontWeight','bold','Layer','top','LineWidth',3,'XGrid','on',...
            'YGrid','on');
        xs1 = c1(1,2:c1(2,1)+1);
        ys1 = c1(2,2:c1(2,1)+1);
        xs2 = c2(1,2:c2(2,1)+1);
        ys2 = c2(2,2:c2(2,1)+1);
        time(ti+1) = t;
        [radius(ti+1),id] = max(ys2);
        plot(xs2(id),radius(ti+1),'kx','markerSize',30)
        saveas(gcf,image)
        close all
        Interface{ti+1} = {[xs1' ys1'], [xs2' ys2']};
    end
    fprintf('Done %d of %d.\n',ti+1,nGFS+1);
end
% Interface contains all the interfacial points in the form of cells.
% Interface{ti+1}{1} contains (x,y) for f1 for time stamp given by ti
% Interface{ti+1}{2} contains (x,y) for f2 for time stamp given by ti
save('TriplePoint.mat','Interface','time','radius')
fprintf('\n You job is finished.\n');
