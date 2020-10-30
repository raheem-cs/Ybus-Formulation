% This software will convert the impedance diagram to Y-Bus matrix
% Enter the data and this will prepare the Y-Bus matrix for you
% Down a sample of data should be entered in this fashion
% Coded by: RAHEEM ELSAYED
 
%   From        To          R           X           Yc/2
Z = [1          2           0.05        0.15        0.01;
     1          3           0.1         0.3         0.02;
     2          3           0.15        0.45        0.03;
     2          4           0.1         0.3         0.02;
     3          4           0.05        0.15        0.01];
 
% Get the Y-Bus matrix dimensions
buses = max(max(Z(:,1)), max(Z(:,2))); % The max between From and To
 
% Create the Y-Bus matrix - Initialized to zeros
Y = zeros(buses, buses);
 
% Some variables used while forming the diagonal element of the Y-Bus matrix
bus = 1;
impedance = 0;
c = 1;
elements = [];
admittance = [];
 
% Forming the diagonal element
for zrow = 1:max(size(Z))
    
    for irow = 1:max(size(Z))
        if ((Z(irow, 1) == bus) ||  (Z(irow, 2) == bus))
            for column = 3:5
                if (column == 3)
                    impedance = Z(irow, 3);
                elseif (column == 4)
                    impedance = impedance + j*Z(irow, 4);
                else
                    admittance(c) = (1/impedance) + Z(irow, column)*j;
                    c = c + 1;
                end
            end
        end
    end
    
    elements(zrow) = sum(admittance);
    
    for k = 1:max(size(admittance))
        admittance(k) = 0;
    end
    
    c = 1;
    bus = bus + 1;
    
end
 
% Filter the diagonal elements from any zeros
diagonal = elements(elements~=0);
 
% Here we form the of-diagonal elements and fill the Y-Bus matrix
for row = 1:buses
    for column = 1:buses
        if (row == column)
            Y(row, column) = diagonal(row);
        else
            for irow = 1:max(size(Z))
                if (((Z(irow, 1) == row) ||  (Z(irow, 2) == row)) && ((Z(irow, 1) == column) ||  (Z(irow, 2) == column)))
                    for xcolumn = 3:5
                        if (xcolumn == 3)
                            impedance = Z(irow, 3);
                        elseif (xcolumn == 4)
                            impedance = impedance + j*Z(irow, 4);
                        end
                    end
                    
                    Y(row, column) = -1*(1/impedance);
                    
                end
            end
        end
    end
end
 
% Here we display the resulted Y-Bus matrix
disp('Y-Bus Matrix is:');
disp(Y);