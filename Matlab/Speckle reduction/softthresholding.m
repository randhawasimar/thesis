clear all;
t=1.25;
x=-5:0.25:5;
for i=1:length(x)
    a=x(i);
if (abs(a)<t)
    st(i)=0;
elseif(abs(a)>=t)
    st(i)=sign(a)*(abs(a)-t);
end
end
plot(x,st)
grid on
xlabel('w');
ylabel('Fs(w)');
title('Soft Thresholding');
