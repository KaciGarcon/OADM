clear all
clc

vls = [0, 1, 2, 3, 4, 5]*50
xs  = [0, 1, 2, 3, 4, 5, 6]*50

prfts = transpose([0 0 0 0; 17 25 20 30; 38 40 35 45; 50 48 52 50; 55 56 60 55; 60 62 68 68])

x4 = 0;

tableX3 = zeros(length(vls), 3);
for x3 = 1:length(xs)
    tableX3(x3,1) = xs(x3);
    index = find(vls == xs(x3), 1);
    if ~isempty(index)
        tableX3(x3,2) = prfts(4, x3);
        tableX3(x3,3) = vls(index);
    else
        tableX3(x3,2) = NaN;
        tableX3(x3,3) = NaN;
    end
end
disp('    X3    S3    U3s')
disp(' ------------------')
disp(tableX3)



tableX2big = zeros(length(vls)*length(xs), 6);
tableX2 = zeros(length(xs), 2);
for col = [1, 2, 3, 4, 5, 6, 7]
    for x2 = 1:length(xs)
       for u2 = 1:length(vls)
            switch col
                case 1 % X2
                    tableX2big((x2-1)*length(vls)+u2, col) = xs(x2);
                case 2 % U2
                    tableX2big((x2-1)*length(vls)+u2, col) = vls(length(xs)-u2);
                case 3 % L2
                    tableX2big((x2-1)*length(vls)+u2, col) = prfts(3, length(xs)-u2);
                case 4 % X3
                    tempval = tableX2big((x2-1)*length(vls)+u2, 1) - tableX2big((x2-1)*length(vls)+u2, 2);
                    tableX2big((x2-1)*length(vls)+u2, col) = tempval;
                case 5 % S3
                    index = find(xs == tableX2big((x2-1)*length(vls)+u2, 4), 1);
                    if ~isempty(index)
                        tableX2big((x2-1)*length(vls)+u2, col) = tableX3(index, 2);
                    else
                        tableX2big((x2-1)*length(vls)+u2, col) = NaN;
                    end
                case 6 % G2
                    tableX2big((x2-1)*length(vls)+u2, col) = tableX2big((x2-1)*length(vls)+u2, 3) + tableX2big((x2-1)*length(vls)+u2, 5);
            end
        end
    end
end
for x2 = 1:length(xs)
    tableX2(x2, 1) = tableX2big((x2-1)*length(vls)+1, 1);
    maxV = nanmax(tableX2big((x2-1)*length(vls)+1:(x2)*length(vls), 6));
    tableX2(x2, 2) = maxV;
    [xposes, yposes] = find(tableX2big((x2-1)*length(vls)+1:(x2)*length(vls), 6) == maxV);
    for i = 1:length(xposes)
        if i > size(tableX2,2)-2
            tableX2(1:length(xs), 2+i) = NaN;
        end
        tableX2(x2, 2+i) = tableX2big((x2-1)*length(vls)+xposes(i), 2);
    end
end

disp('    X2    U2    L2    X3    S3    G2 ')
disp('-------------------------------------')
disp(tableX2big)

disp('    X2    S2    U2s')
disp(' ------------------')
disp(tableX2)



tableX1big = zeros(length(vls)*length(xs), 6);
tableX1 = zeros(length(xs), 2);
for col = [1, 2, 3, 4, 5, 6, 7]
    for x1 = 1:length(xs)
       for u2 = 1:length(vls)
            switch col
                case 1 % X1
                    tableX1big((x1-1)*length(vls)+u2, col) = xs(x1);
                case 2 % U2
                    tableX1big((x1-1)*length(vls)+u2, col) = vls(length(xs)-u2);
                case 3 % L2
                    tableX1big((x1-1)*length(vls)+u2, col) = prfts(2, length(xs)-u2);
                case 4 % X2
                    tempval = tableX1big((x1-1)*length(vls)+u2, 1) - tableX1big((x1-1)*length(vls)+u2, 2);
                    tableX1big((x1-1)*length(vls)+u2, col) = tempval;
                case 5 % S3
                    index = find(xs == tableX1big((x1-1)*length(vls)+u2, 4), 1);
                    if ~isempty(index)
                        tableX1big((x1-1)*length(vls)+u2, col) = tableX2(index, 2);
                    else
                        tableX1big((x1-1)*length(vls)+u2, col) = NaN;
                    end
                case 6 % G2
                    tableX1big((x1-1)*length(vls)+u2, col) = tableX1big((x1-1)*length(vls)+u2, 3) + tableX1big((x1-1)*length(vls)+u2, 5);
            end
        end
    end
end
for x1 = 1:length(xs)
    tableX1(x1, 1) = tableX1big((x1-1)*length(vls)+1, 1);
    maxV = nanmax(tableX1big((x1-1)*length(vls)+1:(x1)*length(vls), 6));
    tableX1(x1, 2) = maxV;
    [xposes, yposes] = find(tableX1big((x1-1)*length(vls)+1:(x1)*length(vls), 6) == maxV);
    for i = 1:length(xposes)
        if i > size(tableX1,2)-2
            tableX1(1:length(xs), 2+i) = NaN;
        end
        tableX1(x1, 2+i) = tableX1big((x1-1)*length(vls)+xposes(i), 2);
    end
end

disp('    X1    U1    L1    X2    S2    G1 ')
disp('-------------------------------------')
disp(tableX1big)

disp('    X1    S1    U1s')
disp(' ------------------')
disp(tableX1)



tableX0big = zeros(length(vls)*length(xs), 6);
tableX0 = zeros(length(xs), 2);
for col = [1, 2, 3, 4, 5, 6, 7]
    for x0 = 1:length(xs)
       for u2 = 1:length(vls)
            switch col
                case 1 % X0
                    tableX0big((x0-1)*length(vls)+u2, col) = xs(x0);
                case 2 % U2
                    tableX0big((x0-1)*length(vls)+u2, col) = vls(length(xs)-u2);
                case 3 % L2
                    tableX0big((x0-1)*length(vls)+u2, col) = prfts(1, length(xs)-u2);
                case 4 % X1
                    tempval = tableX0big((x0-1)*length(vls)+u2, 1) - tableX0big((x0-1)*length(vls)+u2, 2);
                    tableX0big((x0-1)*length(vls)+u2, col) = tempval;
                case 5 % S3
                    index = find(xs == tableX0big((x0-1)*length(vls)+u2, 4), 1);
                    if ~isempty(index)
                        tableX0big((x0-1)*length(vls)+u2, col) = tableX1(index, 2);
                    else
                        tableX0big((x0-1)*length(vls)+u2, col) = NaN;
                    end
                case 6 % G2
                    tableX0big((x0-1)*length(vls)+u2, col) = tableX0big((x0-1)*length(vls)+u2, 3) + tableX0big((x0-1)*length(vls)+u2, 5);
            end
        end
    end
end
for x0 = 1:length(xs)
    tableX0(x0, 1) = tableX0big((x0-1)*length(vls)+1, 1);
    maxV = nanmax(tableX0big((x0-1)*length(vls)+1:(x0)*length(vls), 6));
    tableX0(x0, 2) = maxV;
    [xposes, yposes] = find(tableX0big((x0-1)*length(vls)+1:(x0)*length(vls), 6) == maxV);
    for i = 1:length(xposes)
        if i > size(tableX0,2)-2
            tableX0(1:length(xs), 2+i) = NaN;
        end
        tableX0(x0, 2+i) = tableX0big((x0-1)*length(vls)+xposes(i), 2);
    end
end

disp('    X0    U0    L0    X1    S1    G0 ')
disp('-------------------------------------')
disp(tableX0big)

disp('    X0    S0    U0s')
disp(' ------------------')
disp(tableX0)
