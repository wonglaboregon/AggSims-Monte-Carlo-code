function MakeAllPlots(Grid,Tinit,Tfinal)
path='C:\Users\Cathy\Desktop\Figs\';
for T=Tinit:Tfinal
    
%     ShowGrid3D(Grid(T),0,3,1,0,0);
%     set(gca,'CameraPosition',[-100,-200,100]);
%     % set(gca,'Box','on','BoxStyle','full');
%     set(gca,'Visible','off');
%     filename=[path,num2str(T,'%04d'),'.jpg'];
%     saveas(gcf,filename);
%     close(gcf);
    ShowGrid3D(Grid(T),0,3,1,1,0);
    set(gca,'CameraPosition',[-100,-200,100]);
    % set(gca,'Box','on','BoxStyle','full');
    set(gca,'Visible','off');
    filename=[path,'S',num2str(T,'%04d'),'.jpg'];
    saveas(gcf,filename);
    close(gcf);
end

end

