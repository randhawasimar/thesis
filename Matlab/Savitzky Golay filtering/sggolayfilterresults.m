clc;
clear all;
filename='E:\phd\SGfilterpaper\results.xlsx';
x=[11;13;15;17;19;21;23;25;27;29;31;33;35;37;39;41;43;45];
a=xlsread(filename,1,'D2:E91');
mse2=a(1:18,1);
mse4=a(19:36,1);
mse6=a(37:54,1);
mse8=a(55:72,1);
mse10=a(73:90,1);
psnr2=a(1:18,2);
psnr4=a(19:36,2);
psnr6=a(37:54,2);
psnr8=a(55:72,2);
psnr10=a(73:90,2);
figure
plot(x,mse2,'g',x,mse4,'b',x,mse6,'r',x,mse8,'c',x,mse10,'m')
grid on
xlabel('Filter Length')
ylabel('MSE')
legend('order 2','order 4','order 6','order 8','order 10')
figure
plot(x,psnr2,'g',x,psnr4,'b',x,psnr6,'r',x,psnr8,'c',x,psnr10,'m')
grid on
xlabel('Filter Length')
ylabel('PSNR')
legend('order 2','order 4','order 6','order 8','order 10')