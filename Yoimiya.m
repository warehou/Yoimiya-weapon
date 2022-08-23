%% 读表

clear;
clc;
close all;

% list_weapon={'飞雷1','飞雷5','若水1','若水5','冬极1','冬极5','阿莫斯1','阿莫斯5','天空1','天空5','弓藏1','弓藏5','破魔1','破魔5','弹弓5'};
list_weapon={'弹弓5','弓藏1','弓藏5','破魔1','破魔5','飞雷1','若水1','冬极1','阿莫斯1','天空1','飞雷5','若水5','冬极5','阿莫斯5','天空5'};
list_artifest={'追忆','余响'};
list_support={'无辅助','班尼特','云堇','班尼特云堇'};
size_weapon=size(list_weapon,2);
size_artifest=size(list_artifest,2);
size_support=size(list_support,2);

table_combo=cell(size_weapon,size_artifest,size_support);
table_name=cell(size_weapon,size_artifest,size_support);
table_combo_min=zeros(size_weapon,size_artifest,size_support);
table_combo_max=zeros(size_weapon,size_artifest,size_support);





read_xls=0;     
% read_xls=0 读取data_trim.mat; 
% read_xls=1 读取xls;

n=1:50:1001;   % 1001x1001数据表稀疏为21x21

table_min=inf;
table_max=-inf;

if read_xls==1

for su=1:size_support     
    for we=1:size(list_weapon,2) 
        for ar=1 :size(list_artifest,2)

            table_name(we,ar,su)=strcat(list_weapon(we),'+',list_artifest(ar),'+',list_support(su));
            table_name_read=string(table_name(we,ar,su));

            table=xlsread(table_name_read);
         
            table_combo(we,ar,su)=mat2cell(table(n,n),[size(n,2)],[size(n,2)]);
            system('tskill excel');
            
            temp_min=min(min(table));
            if temp_min<table_min
            table_min=temp_min;
            end

            temp_max=max(max(table));
            if temp_max>table_max
            table_max=temp_max;
            end            
        end
    end
end
  
save('data_trim.mat','table_combo');

end

if read_xls==0    %读取data_trim.mat中的数据
    
    table_combo=struct2cell(load("data_trim.mat","table_combo"));
    table_combo=table_combo{1};

    for su=1:size_support
        for we=1:size_weapon
            for ar=1 :size(list_artifest,2)
                table_name(we,ar,su)=strcat(list_weapon(we),'+',list_artifest(ar),'+',list_support(su));
                temp_table=table_combo{we,ar,su};                
                temp_min=min(min(temp_table));
                
                table_combo_min(we,ar,su)=temp_min;
                if temp_min<table_min
                table_min=temp_min;
                end
                temp_max=max(max(temp_table));
                table_combo_max(we,ar,su)=temp_max;
                if temp_max>table_max
                table_max=temp_max;
                end
            end
        end
    end
end

x=0:1/20:1;
y=0:4/20:4;            
[x,y]=meshgrid(x,y);


%% 绘图1  同一辅助条件下，比较各武器


weapon_group_1=1:5;
weapon_group_2=6:10;
weapon_group_3=11:15;


%%%%%%%%%调整此项以变更Figure 1武器分组%%%%%%%%%%%%%%%%5%%%%%%

weapon_group=1:10; %[weapon_group_1，weapon_group_2,weapon_group_3];

%%%%%%%%%调整此项以变更Figure 1武器分组%%%%%%%%%%%%%%%%5%%%%%%
% 1:5   三星四星
%6:10   五星一精
%11:15  五星满精
%最多20幅图像，可以同时发布两组，如1:10或6:15

weapon_group_cat=reshape(repmat({'三星四星','五星一精','五星满精'},[5,1]),1,[]);

weapon_colum_num=size(weapon_group,2)*2/5;  %每行2n列                             
weapon_group_num=5;                         %每列5幅图

support_group=1:4;



% contour_level_lower=floor(table_min*10)/10;
% contour_level_upper=ceil(table_max*10)/10;
% contour_level=[contour_level_lower:0.05:contour_level_upper];
% contour_caxis_limit=[contour_level_lower,contour_level_upper];


for su= 1:size(list_support,2)

contour_level_we_min=min(min(squeeze(table_combo_min(weapon_group,:,su))));
contour_level_we_max=max(max(squeeze(table_combo_max(weapon_group,:,su))));

contour_level_we_lower=floor(contour_level_we_min*10)/10;
contour_level_we_upper=ceil(contour_level_we_max*10)/10;

%等高线间距
contour_level_we_gap=[0.05,0.1,0.1,0.2];    %等高线间距

%contour_level_we_gap=contour_level_we_max-contour_level_we_min;
contour_level_we=[contour_level_we_lower:contour_level_we_gap(su):contour_level_we_upper];
contour_caxis_limit_we=[contour_level_we_lower,contour_level_we_upper];



    for we=weapon_group     %size(list_weapon,2)       
                       
            table1_1=table_combo{we,1,su};
            table1_2=table_combo{we,2,su};
            table_1=table1_1; %cell2mat(table1(n,n));
            table_2=table1_2; %cell2mat(table2(n,n));
%             sc1=mesh(x,y,table_1);
%             sc2=mesh(x,y,table_2);
%             view(-50,60);
%             axis equal;

%             table_min=min(min(min(table_1),min(min(table_2))));
%             table_max=max(max(max(table_1),max(max(table_2))));
                                    
            figure (su) 
            set(gcf,'Position',[100 -200 400*weapon_colum_num 1200]);   %图像分辨率
            
            colormap("turbo");

            fig_col=weapon_colum_num;          %比较两套圣遗物=必为双数
            fig_row=weapon_group_num;       
            
%             if mod(we,fig_row)==0
%                 fig_we=fig_row;
%             else
%                 fig_we=mod(we,fig_row);
%             end
            fig_we_mod=mod(we+fig_row-1,fig_row)+1;
            fig_we_num=we-weapon_group(1)+1;

            if fig_we_num<=fig_row  %左侧十幅图

                subplot(weapon_group_num,fig_col,fig_col*(fig_we_mod-1)+1);

                subplot_title_1=table_name(we,1,su);
                [ct1,c1]=contourf(x,y,table_1,contour_level_we,'k','ShowText','on','LineWidth',1);
                caxis(contour_caxis_limit_we);
                title(subplot_title_1);
                xlabel('攻击力占比');
                ylabel('圣遗物');
                set(gca,'FontName','Microsoft YaHei');
    
    
                subplot(weapon_group_num,fig_col,fig_col*(fig_we_mod-1)+2);

                [ct2,c2]=contourf(x,y,table_2,contour_level_we,'k','ShowText','on','LineWidth',1);
                caxis(contour_caxis_limit_we);
                subplot_title_2=table_name(we,2,su);
                title(subplot_title_2);
                xlabel('攻击力占比');
                ylabel('圣遗物');

                set(gca,'FontName','Microsoft YaHei');

            else    %右侧十幅图
            subplot(weapon_group_num,fig_col,fig_col*(fig_we_num-fig_row)-1);
            subplot_title_1=table_name(we,1,su);
            ct1=contourf(x,y,table_1,contour_level_we,'k','ShowText','on','LineWidth',1);
            caxis(contour_caxis_limit_we);
            title(subplot_title_1);
            xlabel('攻击力占比');
            ylabel('圣遗物');
            set(gca,'FontName','Microsoft YaHei');


            subplot(weapon_group_num,fig_col,fig_col*(fig_we_num-fig_row));
            ct2=contourf(x,y,table_2,contour_level_we,'k','ShowText','on','LineWidth',1);
            caxis(contour_caxis_limit_we);
            subplot_title_2=table_name(we,2,su);
            title(subplot_title_2);
            xlabel('攻击力占比');
            ylabel('圣遗物');
            set(gca,'FontName','Microsoft YaHei');

            end
    end
    if size(weapon_group,2)==5
        fig_title_1=strcat('霄宫',weapon_group_cat(we-5),'+',list_support{su},' by 甜柚子 & 1A7489 @米游社');
    end
    if size(weapon_group,2)==10
        fig_title_1=strcat('霄宫',weapon_group_cat(we-5),'VS',weapon_group_cat(we),'+',list_support{su},' by 甜柚子 & 1A7489 @米游社');
    end
    sgt=sgtitle(fig_title_1);
    sgt.FontName='Microsoft YaHei';
    
    fig_filename_1=strcat('武器',num2str(weapon_group(1)),'~',num2str(weapon_group(end)),'+',list_support{su},'.png');
    saveas(gcf,fig_filename_1);
end
            
%% 绘图2 比较两种种武器

weapon_auto=2;
% refine_auto=0  手动输入需要比较的武器
% refine_auto=1  自动生成同种武器精一精五
% refine_auto=2  自动生成每件武器两种圣遗物

fig_gif=0;
% fig_gif=0;    仅显示三维云图绘制过程, 不输出gif
% fig_gif=1;    不绘制二维云图，输出gif



if weapon_auto==0
list_weapon_table=table([1:size(list_weapon,2)]',cell2table(list_weapon'));
disp(list_weapon_table);

we_compare1=input('请输入第一件武器编号：');
while ismember(we_compare1,[1:size(list_weapon,2)])==0
    we_compare1=input('请输入第一件武器编号：');
end
ar_compare1=input('请输入第一件武器搭配圣遗物 1-追忆；2-余响：');
while ismember(ar_compare1,[1:size(list_artifest,2)])==0
    x=input('请输入第一件武器搭配圣遗物 1-追忆；2-余响：');   
end
we_compare2=input('请输入第二件武器编号：');
while ismember(we_compare2,[1:size(list_weapon,2)])==0
    we_compare2=input('请输入第二件武器编号：');
end
ar_compare2=input('请输入第二件武器搭配圣遗物 1-追忆；2-余响：');
while ismember(ar_compare2,[1:size(list_artifest,2)])==0
    ar_compare2=input('请输入第二件武器搭配圣遗物 1-追忆；2-余响：');   
end

%'辅助'字段列表
list_support_table=table([1:size(list_support,2)]',cell2table(list_support'));
disp(list_support_table);

su=1;
su_compare=[];
su_compare(1)=su;
su_compare_temp=1;
i=2;
while and(ismember(su_compare_temp,[1:4]),i<=4)
    su_compare_temp=input('请输入想要比较的辅助,按任意键为无辅助:');
    if ismember(su_compare_temp,[1:4])
        su_compare(i)=su_compare_temp;
    else
        su_compare_temp=0;
    end
    i=i+1;
end
weapon_compare=we_compare1;

else        
    su_compare=[1:4];
    
    if weapon_auto==1
    weapon_compare=[2,4,6:10];      %AUTO1模式：比较精一精五
    ar_compare_temp=input('请输入搭配圣遗物 1-追忆；2-余响：'); %指定圣遗物套装
    ar_compare1=ar_compare_temp;
    ar_compare2=ar_compare_temp;
    end

    if weapon_auto==2               %Auto2模式：比较同种武器不同圣遗物；
    weapon_compare=[1:15];
    ar_compare1=1;
    ar_compare2=2;    
    end
end

   
for we=weapon_compare  % 2:15 %  size(list_weapon,2)

    if weapon_auto==1         % Auto1分支比较同一武器精一&精五   
        if or(we==2,we==4)
            we_compare1=we;
            we_compare2=we+1;
        else                    
            if or(we>=5,we<=10)
            we_compare1=we;
            we_compare2=we+5;                
            end
        end
    end

    if weapon_auto==2
        we_compare1=we;
        we_compare2=we;
    end
    
    %=========输出文件名========
    if we_compare1==we_compare2 
        fig_filename_2_we=list_weapon{we_compare1};
    else 
        fig_filename_2_we=strcat(list_weapon{we_compare1},'&',list_weapon{we_compare2});
    end    
    if ar_compare1==ar_compare2
        fig_filename_2_ar=list_artifest{ar_compare1};
    else 
        fig_filename_2_ar=strcat(list_artifest{ar_compare1},'&',list_artifest{ar_compare2});
    end
    fig_filename_2_su=strcat(list_support{su_compare(end)},num2str(sum(su_compare)));

    fig_filename_2=strcat(num2str(weapon_auto),'Auto-',fig_filename_2_we,'+',fig_filename_2_ar,'+',fig_filename_2_su,'.png');
    fig_filename_2_gif=strcat(num2str(weapon_auto),'Auto-',fig_filename_2_we,'+',fig_filename_2_ar,'+',fig_filename_2_su,'.gif');


    %取出选定武器&圣遗物的所有辅助的极值作为坐标范围
    contour_level_su_max_1=squeeze(table_combo_max(we_compare1,ar_compare1,:));
    contour_level_su_min_1=squeeze(table_combo_min(we_compare1,ar_compare1,:));
    contour_level_su_max_2=squeeze(table_combo_max(we_compare2,ar_compare2,:));
    contour_level_su_min_2=squeeze(table_combo_min(we_compare2,ar_compare2,:));

    fig2=figure (we_compare1+10);
    set(gcf,'Position',[100 -200 480 480+180*(size(su_compare,2)-1)]);        %分辨率
    subplot_row=2;
    subplot_col=2;

    sub0=subplot(subplot_row,subplot_col,1);    
    sgt=sgtitle('宵宫武器对比 by 甜柚子 & 1A7489 @米游社');
    sgt.FontName='Microsoft YaHei';

    if fig_gif ~= 1
    i_su=1;     %二维云图

    subplot_row=size(su_compare,2)+2;
    subplot_col=2;

    for su=su_compare
    contour_level_su_max=max([contour_level_su_max_1(su);contour_level_su_max_2(su)]);
    contour_level_su_min=min([contour_level_su_min_1(su);contour_level_su_min_2(su)]);

    contour_level_su_lower=floor(contour_level_su_min*10)/10;
    contour_level_su_upper=ceil(contour_level_su_max*10)/10;

    contour_level_we_gap=[0.05,0.1,0.1,0.2];    %等高线间距

    contour_level_su=[contour_level_su_lower:contour_level_we_gap(su):contour_level_su_upper];
    contour_caxis_limit_su=[contour_level_su_lower,contour_level_su_upper];

    subplot(subplot_row,subplot_col,i_su*2+3);
    subplot_title=table_name(we_compare1,ar_compare1,su);
    contourf(x,y,table_combo{we_compare1,ar_compare1,su},contour_level_su,'k','ShowText','on','LineWidth',1);
    set(gca,'XDir','reverse');
    set(gca,'YDir','reverse');
    caxis(contour_caxis_limit_su);
    title(subplot_title);
    xlabel('攻击力占比');
    ylabel('圣遗物');
    set(gca,'FontName','Microsoft YaHei');  

    subplot(subplot_row,subplot_col,i_su*2+4);
    subplot_title=table_name(we_compare2,ar_compare2,su);
    contourf(x,y,table_combo{we_compare2,ar_compare2,su},contour_level_su,'k','ShowText','on','LineWidth',1);
    set(gca,'XDir','reverse');
    set(gca,'YDir','reverse');
    caxis(contour_caxis_limit_su);
    title(subplot_title);
    xlabel('攻击力占比');
    ylabel('圣遗物');
    set(gca,'FontName','Microsoft YaHei');

    i_su=i_su+1;
    end 
    end



    i_su=1;     %三维云图
    for su=su_compare
        
        contour_level_su_max=max([contour_level_su_max_1(su);contour_level_su_max_2(su)]);
        contour_level_su_min=min([contour_level_su_min_1(su);contour_level_su_min_2(su)]);
    
        contour_level_su_lower=floor(contour_level_su_min*10)/10;
        contour_level_su_upper=ceil(contour_level_su_max*10)/10;
    
        contour_level_we_gap=[0.05,0.1,0.1,0.2];    %手动设置等高线间距
    
        contour_level_su=[contour_level_su_lower:contour_level_we_gap(su):contour_level_su_upper];
    
        contour_caxis_limit_su=[contour_level_su_lower,contour_level_su_upper];
    
        
    %     table_3=table_combo{we_compare1,ar_compare1,su};     %比较基准为无辅助
    %     table_4=table_combo{we_compare2,ar_compare2,su}; 
    
    
    %   set(gcf,'WindowState','maximized');
   
        subplot_locate_1=[1,subplot_col+1];
        subplot_locate_2=[2,subplot_col+2];
    
        sub1=subplot(subplot_row,subplot_col,subplot_locate_1);
            
            for su_draw=su_compare(1:i_su)
            sc1=mesh(x,y,table_combo{we_compare1,ar_compare1,su_draw});
            sc1.FaceColor='flat';
            hold on
            end
    
            caxis(contour_caxis_limit_su);
            zlim(contour_caxis_limit_su);
            view(200,10)
            %sc1.FaceAlpha='0.1';
            title(strcat(list_weapon(we_compare1),'+',list_artifest(ar_compare1),'+',list_support(su_compare(i_su))));
            xlabel('攻击力占比');
            ylabel('圣遗物','rotation',0);        
            set(gca,'FontName','Microsoft YaHei');
            grid on
            
        sub2=subplot(subplot_row,subplot_col,subplot_locate_2);
            for su_draw=su_compare(1:i_su)
            sc2=mesh(x,y,table_combo{we_compare2,ar_compare2,su_draw});           
            sc2.FaceColor='flat';
            hold on
            end

            caxis(contour_caxis_limit_su);
            zlim(contour_caxis_limit_su);
            view(200,10)
            %sc2.FaceAlpha='0.1';
            title(strcat(list_weapon(we_compare2),'+',list_artifest(ar_compare2),'+',list_support(su_compare(i_su))));
            xlabel('攻击力占比');
            ylabel('圣遗物','rotation',0);
            set(gca,'FontName','Microsoft YaHei');
            grid on
            drawnow
            fig_frame=getframe(fig2);           %fig第一帧
            fig_im{1}=frame2im(fig_frame);      


        pause(2)        
        i_su=i_su+1;


    %三维图旋转

    i_fig=1;
    [fig_A,fig_map]=rgb2ind(fig_im{i_fig},256);
    
    imwrite(fig_A,fig_map,fig_filename_2_gif,'gif','LoopCount',Inf,'DelayTime',2);

    gap=0.2;
    t_end=3;
    t_seq=0:gap:t_end;        
    for t=t_seq
        i_fig=i_fig+1;
        subplot(sub1)
        view(200+360/t_end*(t_end-t),10)
        subplot(sub2)
        view(200+360/t_end*(t_end-t),10)
        pause(gap);
        
        % gif输出
        fig_frame=getframe(fig2);
        fig_im{i_fig}=frame2im(fig_frame);        
        [fig_A,fig_map]=rgb2ind(fig_im{i_fig},256);
        imwrite(fig_A,fig_map,fig_filename_2_gif,'gif','WriteMode','append','DelayTime',gap);
                                    
    end
    
    end

    saveas(gcf,fig_filename_2);
    
    
end


