%% Getting the triple point contact line
% Author: Vatsal Sanjay
% vatsalsanjay@gmail.com
% Physics of Fluids
clc
clear
close
load('Interface.mat')
%% Fir part 1, uncomment the lines in this section. This will help in manually finding the triple point using Matlab
% figure1 = figure('visible','on','WindowState','fullscreen','Color',[1 1 1]);
% axes1 = axes('Parent',figure1);
% hold(axes1,'on');
% ylabel('\textbf{Y/R}','FontSize',35,'Interpreter','latex');
% xlabel('\textbf{X/R}','FontSize',35,'Interpreter','latex');
% box(axes1,'on');
% set(axes1,'BoxStyle','full','FontName','times new roman','FontSize',25,...
%     'FontWeight','bold','Layer','top','LineWidth',3,'XGrid','on',...
%     'YGrid','on');
% TYPEC = struct([]); TYPEC{1} = 'r-'; TYPEC{2} = 'b-'; TYPEC{3} = 'g-';
% 
% for counter = 1:1:length(Interface)
%     typeCounter = 1;
%     for p = 1:2:5
%         plot(InterfaceC{counter}{6-p},InterfaceC{counter}{6-p+1},TYPEC{4-typeCounter},'linewidth',3)
%         hold on
%         typeCounter = typeCounter + 1;
%     end
% end

%% In between -> Manual. In the To Do to automate this part
% for i = 1:1:32
%     temp = cur(i).Position;
%     X(i,1) = temp(1);
%     X(i,2) = temp(2);
% end
%% For part 2, uncomment the lines below (make sure Xc is present in Interface.mat)
folder = 'TriplePoint'; % output folder
opFolder = fullfile(cd, folder);
if ~exist(opFolder, 'dir')
mkdir(opFolder);
end

for counter = 1:1:25
    figure1 = figure('visible','off','WindowState','fullscreen','Color',[1 1 1]);
    subplotTemp = struct([]);
    TYPE = struct([]); TYPE{1} = 'r.-'; TYPE{2} = 'b.-'; TYPE{3} = 'g.-';
    TYPEC = struct([]); TYPEC{1} = 'r-'; TYPEC{2} = 'b-'; TYPEC{3} = 'g-';
    subplot1 = subplot(1,2,1,'Parent',figure1);
    typeCounter = 1;
    for p = 1:2:5
        for k = 1:2:length(Interface{counter}{6-p})
            plot(Interface{counter}{6-p}(k:k+1)-Xc(counter,1),...
                Interface{counter}{6-p+1}(k:k+1)-Xc(counter,2),TYPE{4-typeCounter},...
                'MarkerSize',25,'linewidth',3)
            hold on
        end
        typeCounter = typeCounter + 1; 
    end
    box(subplot1,'on');
    set(subplot1,'FontName','times new roman','FontSize',25,'FontWeight','bold',...
        'LineWidth',2);
    xlabel('\boldmath{$X/D$}','LineWidth',2,'FontWeight','bold','FontSize',30,...
        'FontName','times new roman',...
        'Interpreter','latex');
    ylabel('\boldmath{$Y/D$}','LineWidth',2,'FontWeight','bold','FontSize',30,...
        'FontName','times new roman',...
        'Interpreter','latex'); 
    axis equal
    xlim([-0.015 0.015])
    ylim([-0.015 0.015])
    title(sprintf('$t^* = %2.1f$',counter*0.1),'FontSize',30,'Interpreter','latex');
    %%
    subplot2 = subplot(1,2,2,'Parent',figure1);
    typeCounter = 1;
    for p = 1:2:5
        plot(InterfaceC{counter}{6-p}-Xc(counter,1),...
            InterfaceC{counter}{6-p+1}-Xc(counter,2),...
            TYPEC{4-typeCounter},'linewidth',3)
        hold on
        typeCounter = typeCounter + 1; 
    end
    axis equal
    xlim([-0.01 0.01])
    ylim([-0.01 0.01])
    box(subplot2,'on');
    set(subplot2,'FontName','times new roman','FontSize',25,'FontWeight','bold',...
        'LineWidth',2);
    xlabel('\boldmath{$X/D$}','LineWidth',2,'FontWeight','bold','FontSize',30,...
        'FontName','times new roman',...
        'Interpreter','latex');
    ylabel('\boldmath{$Y/D$}','LineWidth',2,'FontWeight','bold','FontSize',30,...
        'FontName','times new roman',...
        'Interpreter','latex'); 
    axis equal
    xlim([-0.015 0.015])
    ylim([-0.015 0.015])
    title(sprintf('$t^* = %2.1f$',counter*0.1),'FontSize',30,'Interpreter','latex');

    set(figure1,'pos',[1 1 1024 512]);
    image = [folder '/' sprintf('%6.6d',counter)];
    print(image,'-dpng','-r300')
    close all
    fprintf('%d\n',counter)
end
