
fid = fopen( 'results.txt', 'wt' );
N=10;
a1=10;
a2=20;
a3=30;
a4=40;
for image = 1:N
%   [a1,a2,a3,a4] = ProcessMyImage(image);
  fprintf(fid, '%f,%f,%f,%f\n', a1, a2, a3, a4);
end
fclose(fid);