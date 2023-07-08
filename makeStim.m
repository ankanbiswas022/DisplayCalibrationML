function [imdata] = makeStim(TrialRecord,MLConfig)

PixelsPerDegree = MLConfig.Screen.PixelsPerDegree;
RefreshRate = MLConfig.Screen.RefreshRate;

ApertureRadius = 32;        % deg
h = TrialRecord.CurrentConditionInfo.h;
s = TrialRecord.CurrentConditionInfo.s;
v = TrialRecord.CurrentConditionInfo.v;

[rV,gV,bV]=hsv2rgb([h s v]);

x = (-ApertureRadius*PixelsPerDegree:ApertureRadius*PixelsPerDegree) / PixelsPerDegree;
y = x;
cx = mean(x);
cy = cx;
[x,y] = meshgrid(x,y);


imdata = zeros([size(x) 4]);  % Y-by-X-by-4-by-N
alpha = realsqrt((x-cx).^2 + (y-cy).^2) < ApertureRadius;
sCmap = size(alpha);

r=repmat(rV,sCmap);
g=repmat(gV,sCmap);
b=repmat(bV,sCmap);

imdata(:,:,:) = cat(3,alpha,r,g,b);  % [a r g b]

end
