function [EdgeError,percentedge] = DetermineEdgeError(x,nmerbulk, nmeredge)
erroredges = zeros(6,numel(x));
erroredges(1,x-min(x)+1) = 2*5*x.^2+2*5*x.*(x-10)+5*(x-10).^2;
erroredges(2,x-min(x)+1) = 2*5*x.^2+2*5*x.*(x-10)+(x-10).^2;
erroredges(3,x-min(x)+1) = 2*5*x.^2+5*x.*(x-10)+x.*(x-10)+(x-10).*(x-6);
erroredges(4,x-min(x)+1) = 2*5*x.^2+2*x.*(x-10)+(x-10).*(x-2);
erroredges(5,x-min(x)+1) = 5*x.^2+x.^2+2*x.*(x-6)+(x-6).*(x-2);
erroredges(6,x-min(x)+1) = 2*x.^2+2*x.*(x-2)+(x-4).^2;
totalsites=x.^3;
percentedge = 100*(erroredges)./(totalsites);
EdgeError = abs((nmerbulk-nmeredge)/nmerbulk)*percentedge;

figure()
plot(x,percentedge(1,:), x,percentedge(2,:),x,percentedge(3,:),x,percentedge(4,:),x,percentedge(5,:),x,percentedge(6,:))
figure()
plot(x,EdgeError(1,:), x,EdgeError(2,:),x,EdgeError(3,:),x,EdgeError(4,:),x,EdgeError(5,:),x,EdgeError(6,:))
