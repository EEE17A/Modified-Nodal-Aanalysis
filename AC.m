clc
close all;
clear
%% Declaring Circuit Parameters

fileID = fopen("Example-3.txt");
netlist = textscan(fileID,'%s %s %s %s %s %s');
fclose(fileID);

R=[];
Cap=[];
L=[];
V=[];
d = [];
I = [];
VCVS = [];
CCVS = [];
VCCS = [];
CCCS = [];
node=0;
f=50;
for i = 1 : length(netlist{1})
    s = netlist{1}{i};
    switch(s(1))
        case{'R','r'}
            name  = netlist{1}{i};
            node1 = str2double(netlist{2}{i});
            node2 = str2double(netlist{3}{i});
            value = str2double(unitchange(netlist{4}{i}));
            R = [R;node1 node2 value];
            node=max([node,node1,node2]);
        case{'C','c'}
            name  = netlist{1}{i};
            node1 = str2double(netlist{2}{i});
            node2 = str2double(netlist{3}{i});
            value = str2double(unitchange(netlist{4}{i}));
            Cap= [Cap;node1 node2 value];
            node=max([node,node1,node2]);
        case{'L','l'}
            name  = netlist{1}{i};
            node1 = str2double(netlist{2}{i});
            node2 = str2double(netlist{3}{i});
            value = str2double(unitchange(netlist{4}{i}));
            L = [L;node1 node2 value];
            node=max([node,node1,node2]);
        case{'I','i'}
            name  = netlist{1}{i};
            node1 = str2double(netlist{2}{i});
            node2 = str2double(netlist{3}{i});
            value = str2double(unitchange(netlist{4}{i}));
            I = [I;node1 node2 value];
            node=max([node,node1,node2]);
        case{'V','v'}
            node1 = str2double(netlist{2}{i});
            node2 = str2double(netlist{3}{i});
            value = str2double(unitchange(netlist{4}{i}));
            V=[V;node1 node2 value];
            node=max([node,node1,node2]);
        case{'E','e'}
            node1 = str2double(netlist{2}{i});
            node2 = str2double(netlist{3}{i});
            node3 = str2double(netlist{4}{i});
            node4 = str2double(netlist{5}{i});
            gain = str2double(unitchange(netlist{4}{i}));
            VCVS=[VCVS;node1 node2 node3 node4 value];
            node=max([node,node1,node2,node3,node4]);
        case{'G','g'}
            node1 = str2double(netlist{2}{i});
            node2 = str2double(netlist{3}{i});
            node3 = str2double(netlist{4}{i});
            node4 = str2double(netlist{5}{i});
            gain = str2double(unitchange(netlist{4}{i}));
            VCCS=[VCVS;node1 node2 node3 node4 value];
            node=max([node,node1,node2,node3,node4]);
    end
end

%%
independentVoltageSource = size(V, 1); % number of independent voltage sources
voltageControlledVoltageSource = size(VCVS, 1); % number of VCVS
currentControlledVoltageSource = size(CCVS, 1); % number of CCVS
voltageSource = independentVoltageSource + voltageControlledVoltageSource + currentControlledVoltageSource; % total number of voltage sourcesall;
%%
A = zeros(node + voltageSource);
G = zeros(node);
YC = zeros(node);
YL = zeros(node);
B = zeros(node, voltageSource);
C = zeros(voltageSource, node);
D = zeros(voltageSource, voltageSource);
z = zeros(node + voltageSource, 1);
i = zeros(node, 1);
e = zeros(voltageSource, 1);
%%
G = RStamp(G, R); % stamping the G matrix with R
YC = CStamp(YC, Cap); % stamping the Y matrix with C
YL = LStamp(YL, L); % stamping the Y matrix with C
[B, C, e] = VStamp(B, C, e, V); % Stamping the B, C, e matrix for V
sourceCount = independentVoltageSource;

% i = IStamp(i, I); % Stamping the I matrix for Current Sources

[B, C, D] = HStamp(B, D, CCVS, sourceCount); % Stamping B, C, D for H
sourceCount = sourceCount + currentControlledVoltageSource;

[B, C] = Estamp(B, C, VCVS, sourceCount); % Stamping B, C for E
sourceCount = sourceCount + voltageControlledVoltageSource;

% G = GStamp(G, VCCS); % Stamping G matrix for Gs

B = FStamp (B, CCCS, sourceCount); % Stamping the B Matrix for F
Y=1/f*YL+f*YC;
G=G-1i*Y;
A = [G B; C D]; % Forms the A matrix
z = [i; e]; % Forms the Z matrix
X = A\z; % Solution Matrix, node voltages and Source currents
%%
for i = 1 : node
    formatSpec = 'Voltage at node %d, Magnitude : %0.4f V   Angle : %0.4f degree\n';
    fprintf(formatSpec,i,abs(X(i)),180/pi*angle(X(i)));
    x = 0:1/(f*50):4/f;
    y1 = abs(X(i))*sin(2*pi*f*x-angle(X(i)));
    subplot(2,1,1);
    plot(x,y1,'DisplayName',strcat('Voltage at node ',num2str(i)))
    title('Voltage')
    legend show
    hold on
end
for i = 1 : independentVoltageSource
    formatSpec = 'Current from node %d to %d, Magnitude : %0.4f A   Angle : %0.4f degree\n';
    fprintf(formatSpec,V(i, 1),V(i, 2),abs(X(node+i)),180/pi*angle(X(node+i)));
    x = 0:1/(f*50):4/f;
    y1 = abs(X(node+i))*sin(2*pi*f*x-angle(X(node+i)));
    subplot(2,1,2);
    plot(x,y1,'DisplayName',strcat('Current from node', num2str(V(i, 1)), ' to node ',num2str(V(i, 2))))
    title('Current')
    gravstr = sprintf('Current from node %d to %d',V(i, 1),V(i, 2));
    legend show
    hold on
end