f = @(x, y) sin(x-0.2).^2+sin(y+0.3).^2;


x0 = 0
y0 = 0

d1x = 0.1
d1y = 0
d2x = 0
d2y = 0.1

prec = 0.01
n=0
while (d1x+d2x)^2 + (d1y+d2y)^2 > prec^2 

    x2 = x0+d1x+d2x
    y2 = y0+d1y+d2y
    
    d3x = x2-x0
    d3y = y2-y0
    
    funa = @(a) sin(x2+a*d3x-0.2).^2 + sin(y2+a*d3y+0.3).^2;
    alpha = fminbnd(funa,-10,10)
    
    x3 = x2 + alpha*d3x
    y3 = y2 + alpha*d3y
    
    d1x = d2x;
    d1y = d2y;
    d2x = d3x;
    d2y = d3y;
    x0 = x3;
    y0 = y3;
end





clear all

f = @(x, y) sin(x-0.2).^2+sin(y+0.3).^2;

gf = @(x, y) [-2*sin(0.2-x)*cos(0.2-x); 2*sin(y+0.3)*cos(y+0.3)];

x0 = [0; 0]
d1 = -gf(x0(1), x0(2))
x1 = x0+d1

n=0;
while true
    x0
    x1
    
    grad0 = gf(x0(1), x0(2))
    grad1 = gf(x1(1), x1(2))
    
    B1 = grad1' * (grad1 - grad0) / sum(abs(grad0).^2)
    
    d2 = -1 * grad1 + B1*d1
    x2 = x1+d2
    x0 = x1;
    x1 = x2;
    
    if (sqrt(sum(abs(d2).^2)) > 0.001)
        break
    end
end
