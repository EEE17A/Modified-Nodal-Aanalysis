clc
close all;
clear
%% Declaring Circuit Parameters

fileID = fopen("Example-1.txt");
netlist = textscan(fileID,'%s %s %s %s %s %s');
fclose(fileID);

R=[];
C=[];
L=[];
V=[];
d = [];
I = [];
VCVS = [];
CCVS = [];
VCCS = [];
CCCS = [];

for i = 1 : length(netlist{1})
    s = netlist{1}{i};
    switch(s(1))
        case{'R','r'}
            name  = netlist{1}{i};
            node1 = str2double(netlist{2}{i});
            node2 = str2double(netlist{3}{i});
            value = str2double(unitchange(netlist{4}{i}));
            R = [R;node1 node2 value];
        case{'C','c'}
            name  = netlist{1}{i};
            node1 = str2double(netlist{2}{i});
            node2 = str2double(netlist{3}{i});
            value = str2double(unitchange(netlist{4}{i}));
            C= [C;node1 node2 value];
        case{'L','l'}
            name  = netlist{1}{i};
            node1 = str2double(netlist{2}{i});
            node2 = str2double(netlist{3}{i});
            value = str2double(unitchange(netlist{4}{i}));
            L = [L;node1 node2 value];
        case{'I','i'}
            name  = netlist{1}{i};
            node1 = str2double(netlist{2}{i});
            node2 = str2double(netlist{3}{i});
            value = str2double(unitchange(netlist{4}{i}));
            I = [I;node1 node2 value];
        case{'V','v'}
            node1 = str2double(netlist{2}{i});
            node2 = str2double(netlist{3}{i});
            value = str2double(unitchange(netlist{4}{i}));
            V=[V;node1 node2 value];
        case{'E','e'}
            node1 = str2double(netlist{2}{i});
            node2 = str2double(netlist{3}{i});
            node3 = str2double(netlist{4}{i});
            node4 = str2double(netlist{5}{i});
            gain = str2double(unitchange(netlist{4}{i}));
            VCVS=[VCVS;node1 node2 value];
        case{'G','g'}
            node1 = str2double(netlist{2}{i});
            node2 = str2double(netlist{3}{i});
            node3 = str2double(netlist{4}{i});
            node4 = str2double(netlist{5}{i});
            gain = str2double(unitchange(netlist{4}{i}));
            VCCS=[VCVS;node1 node2 value];
    end
end

%%
node = 2; % input node number for now
independentVoltageSource = size(V, 1); % number of independent voltage sources
voltageControlledVoltageSource = size(VCVS, 1); % number of VCVS
currentControlledVoltageSource = size(CCVS, 1); % number of CCVS
voltageSource = independentVoltageSource + voltageControlledVoltageSource + currentControlledVoltageSource; % total number of voltage sourcesall;
%%
A = zeros(node + voltageSource);
G = zeros(node);
B = zeros(node, voltageSource);
C = zeros(voltageSource, node);
D = zeros(voltageSource, voltageSource);
z = zeros(node + voltageSource, 1);
i = zeros(node, 1);
e = zeros(voltageSource, 1);
%%
G = RStamp(G, R); % stamping the G matrix with R

[B, C, e] = VStamp(B, C, e, V); % Stamping the B, C, e matrix for V
sourceCount = independentVoltageSource;

% i = IStamp(i, I); % Stamping the I matrix for Current Sources

[B, C, D] = HStamp(B, D, CCVS, sourceCount); % Stamping B, C, D for H
sourceCount = sourceCount + currentControlledVoltageSource;

[B, C] = Estamp(B, C, VCVS, sourceCount); % Stamping B, C for E
sourceCount = sourceCount + voltageControlledVoltageSource;

G = GStamp(G, VCCS); % Stamping G matrix for Gs

B = FStamp (B, CCCS, sourceCount); % Stamping the B Matrix for F

A = [G B; C D]; % Forms the A matrix
z = [i; e]; % Forms the Z matrix
X = A\z; % Solution Matrix, node voltages and Source currents
%%
for i = 1 : node
    formatSpec = 'Voltage at node %d is %0.4f V\n';
    fprintf(formatSpec,i,X(i));
end
for i = 1 : independentVoltageSource
    formatSpec = 'Current from node %d to %d is %0.4f A\n';
    fprintf(formatSpec,V(i, 1),V(i, 2),X(node+i));
end