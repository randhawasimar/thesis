clc;
clear all;
t=1.25;
x=-5:0.25:5;
for i=1:length(x)
if (abs(x(i))<t)
    ht(i)=0;
elseif(abs(x(i))>=t)
    ht(i)=x(i);

end
end
plot(x,ht)
grid on
xlabel('w');
ylabel('Fh(w)');
title('Hard Thresholding');