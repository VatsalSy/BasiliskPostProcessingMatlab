%%
% Author: Vatsal Sanjay
% vatsalsanjay@gmail.com
% Physics of Fluids
function [X, Y, f1, f2, f3] = getData(datafile, xmin, xmax, ymin, ymax, nx, ny)
disp('Using ./getData to extract data from Basilisk C!')    
tic
exe = sprintf('!./getData %s %s %s %s %s %s %s', datafile, num2str(xmin), num2str(xmax), num2str(ymin), num2str(ymax), num2str(nx), num2str(ny));
ll=evalc(exe); 
bolo=textscan(ll,'%f %f %f %f %f\n'); 
toc
X = reshape(bolo{1},[nx+1,ny+1]);
Y = reshape(bolo{2},[nx+1,ny+1]);
f1 = reshape(bolo{3},[nx+1,ny+1]);
f2 = reshape(bolo{4},[nx+1,ny+1]);
f3 = reshape(bolo{5},[nx+1,ny+1]);
end
