clear all
clc

f = @(x) sin(x(1)-0.2)^2+sin(x(2)+0.3)^2;
gf = @(x) [-2*sin(0.2-x(1))*cos(0.2-x(1)); 2*sin(x(2)+0.3)*cos(x(2)+0.3)];

xMin = -1; xMax = 1;
yMin = -1; yMax = 1;

x0 = [0; 0];
d1 = -gf(x0);
avect = sort([(xMin-x0(1))/d1(1), (yMin-x0(2))/d1(2), (xMax-x0(1))/d1(1), (yMax-x0(2))/d1(2)])
alpha = fminbnd(@(a) f(x0+a*d1), avect(2), avect(3))
x1 = x0+alpha*d1;

while true
    x0
    x1
    
    grad0 = gf(x0)
    grad1 = gf(x1)
    
    d2 = -grad1
    
    avect = sort([(xMin-x1(1))/d2(1), (yMin-x1(2))/d2(2), (xMax-x1(1))/d2(1), (yMax-x1(2))/d2(2)])
    alpha = fminbnd(@(a) f(x1+a*d2), avect(2), avect(3))
    
    x2 = x1+alpha*d2
    x0 = x1;
    x1 = x2;
    
    if (sqrt(sum(abs(alpha*d2).^2)) < 0.001)
        break
    end
end
