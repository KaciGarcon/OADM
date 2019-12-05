clear all
clc

vls = [0, 1, 2, 3, 4, 5]*50
xs  = [0, 1, 2, 3, 4, 5, 6]*50

prfts = transpose([0 0 0 0; 17 25 20 30; 38 40 35 45; 50 48 52 50; 55 56 60 55; 60 62 68 68])

x4 = 0;

tableX3 = zeros(length(vls), 3);
% u3 = x3
for x3 = 1:length(vls)
    tableX3(x3,1) = vls(x3);
    tableX3(x3,2) = vls(x3);
    tableX3(x3,3) = prfts(4, x3);
end
disp('    X3    U3    S3 ')
disp(' ------------------')
disp(tableX3)

tableX2big = zeros(length(vls)*length(xs), 8);
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
                    index = find(vls == tableX2big((x2-1)*length(vls)+u2, 4), 1);
                    if ~isempty(index)
                        tableX2big((x2-1)*length(vls)+u2, col) = tableX3(index, 3);
                    else
                        tableX2big((x2-1)*length(vls)+u2, col) = -Inf;
                    end
                case 6 % G2
                    tableX2big((x2-1)*length(vls)+u2, col) = tableX2big((x2-1)*length(vls)+u2, 3) + tableX2big((x2-1)*length(vls)+u2, 5);
                case 7 % S2, 8 % U2
                    [maxV,maxID] = max(tableX2big((x2-1)*length(vls)+1:(x2)*length(vls), 6));
                    tableX2big((x2-1)*length(vls)+u2, col) = maxV;
                    tableX2big((x2-1)*length(vls)+u2, col+1) =  tableX2big((x2-1)*length(vls)+maxID, 2); % tableX2big((x2-1)*length(vls)+maxID, 2);
            end
        end
    end
end
disp('    X2    U2    L2    X3    S3    G2    S2    U2 ')
disp('-------------------------------------------------')
disp(tableX2big)

tableX2 = zeros(length(xs), 3);
for x2 = 1:length(xs)
    tableX2(x2, 1) = tableX2big((x2-1)*length(vls)+1, 1);
    tableX2(x2, 2) = tableX2big((x2-1)*length(vls)+1, 8);
    tableX2(x2, 3) = tableX2big((x2-1)*length(vls)+1, 7);
end
disp('    X2    U2    S2 ')
disp(' ------------------')
disp(tableX2)


tableX1big = zeros(length(vls)*length(xs), 8);
for col = [1, 2, 3, 4, 5, 6, 7]
    for x1 = 1:length(xs)
       for u2 = 1:length(vls)
            switch col
                case 1 % X2
                    tableX1big((x1-1)*length(vls)+u2, col) = xs(x1);
                case 2 % U2
                    tableX1big((x1-1)*length(vls)+u2, col) = vls(length(xs)-u2);
                case 3 % L2
                    tableX1big((x1-1)*length(vls)+u2, col) = prfts(2, length(xs)-u2);
                case 4 % X3
                    tempval = tableX1big((x1-1)*length(vls)+u2, 1) - tableX1big((x1-1)*length(vls)+u2, 2);
                    tableX1big((x1-1)*length(vls)+u2, col) = tempval;
                case 5 % S3
                    index = find(vls == tableX1big((x1-1)*length(vls)+u2, 4), 1);
                    if ~isempty(index)
                        tableX1big((x1-1)*length(vls)+u2, col) = tableX2(index, 3);
                    else
                        tableX1big((x1-1)*length(vls)+u2, col) = -Inf;
                    end
                case 6 % G2
                    tableX1big((x1-1)*length(vls)+u2, col) = tableX1big((x1-1)*length(vls)+u2, 3) + tableX1big((x1-1)*length(vls)+u2, 5);
                case 7 % S2, 8 % U2
                    [maxV,maxID] = max(tableX1big((x1-1)*length(vls)+1:(x1)*length(vls), 6));
                    tableX1big((x1-1)*length(vls)+u2, col) = maxV;
                    tableX1big((x1-1)*length(vls)+u2, col+1) = tableX1big((x1-1)*length(vls)+maxID, 2);
            end
        end
    end
end
disp('    X1    U1    L1    X2    S2    G1    S1    U1 ')
disp('-------------------------------------------------')
disp(tableX1big)

tableX1 = zeros(length(xs), 3);
for x1 = 1:length(xs)
    tableX1(x1, 1) = tableX1big((x1-1)*length(vls)+1, 1);
    tableX1(x1, 2) = tableX1big((x1-1)*length(vls)+1, 8);
    tableX1(x1, 3) = tableX1big((x1-1)*length(vls)+1, 7);
end
disp('    X1    U1    S1 ')
disp(' ------------------')
disp(tableX1)


tableX0big = zeros(length(vls)*length(xs), 8);
for col = [1, 2, 3, 4, 5, 6, 7]
    for x0 = 1:length(xs)
       for u2 = 1:length(vls)
            switch col
                case 1 % X2
                    tableX0big((x0-1)*length(vls)+u2, col) = xs(x0);
                case 2 % U2
                    tableX0big((x0-1)*length(vls)+u2, col) = vls(length(xs)-u2);
                case 3 % L2
                    tableX0big((x0-1)*length(vls)+u2, col) = prfts(1, length(xs)-u2);
                case 4 % X3
                    tempval = tableX0big((x0-1)*length(vls)+u2, 1) - tableX0big((x0-1)*length(vls)+u2, 2);
                    tableX0big((x0-1)*length(vls)+u2, col) = tempval;
                case 5 % S3
                    index = find(vls == tableX0big((x0-1)*length(vls)+u2, 4), 1);
                    if ~isempty(index)
                        tableX0big((x0-1)*length(vls)+u2, col) = tableX1(index, 3);
                    else
                        tableX0big((x0-1)*length(vls)+u2, col) = -Inf;
                    end
                case 6 % G2
                    tableX0big((x0-1)*length(vls)+u2, col) = tableX0big((x0-1)*length(vls)+u2, 3) + tableX0big((x0-1)*length(vls)+u2, 5);
                case 7 % S2, 8 % U2
                    [maxV,maxID] = max(tableX0big((x0-1)*length(vls)+1:(x0)*length(vls), 6));
                    tableX0big((x0-1)*length(vls)+u2, col) = maxV;
                    tableX0big((x0-1)*length(vls)+u2, col+1) = tableX0big((x0-1)*length(vls)+maxID, 2);
            end
        end
    end
end
disp('    X0    U0    L0    X1    S1    G0    S0    U0 ')
disp('-------------------------------------------------')
disp(tableX0big)

tableX0 = zeros(length(xs), 3);
for x0 = 1:length(xs)
    tableX0(x0, 1) = tableX0big((x0-1)*length(vls)+1, 1);
    tableX0(x0, 2) = tableX0big((x0-1)*length(vls)+1, 8);
    tableX0(x0, 3) = tableX0big((x0-1)*length(vls)+1, 7);
end
disp('    X0    U0    S0 ')
disp(' ------------------')
disp(tableX0)
