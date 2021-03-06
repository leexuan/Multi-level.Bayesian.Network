%%
% 这个版本去掉了一些攻击知识

clear all
False = 1;
True = 2;
Remove = [];

%%
% 定义节点
 a1 =  1;  r1 =  2;  a2 =  3;  r2 =  4;  r3 =  5;  r4 =  6;  r5 =  7;  r6 =  8;  a6 =  9;  r8 = 10; 
 a3 = 11;  a4 = 12;  a5 = 13;  a7 = 14;  r7 = 15;  a8 = 16;  a9 = 17;  r9 = 18; a10 = 19; a11 = 20; 
a12 = 21; a13 = 22; a14 = 23; a15 = 24; a16 = 25; a17 = 26; a18 = 27; a19 = 28; a20 = 29; a21 = 30; 
a22 = 31; a23 = 32; a24 = 33; a25 = 34; a26 = 35; a27 = 36;  f1 = 37;  f2 = 38;  f3 = 39;  f4 = 40; 
 f5 = 41;  f6 = 42;  f7 = 43;  f8 = 44;  f9 = 45; f10 = 46; f11 = 47; f12 = 48;  e1 = 49;  e2 = 50; 
 e3 = 51;  e4 = 52;  e5 = 53;  e6 = 54;  e7 = 55;  e8 = 56;  e9 = 57; e10 = 58; e11 = 59; e12 = 60; 
e13 = 61; e14 = 62; e15 = 63; e16 = 64; 
                    
%%
% 定义 Labels
Labels = {
 'a1',  'r1',  'a2',  'r2',  'r3',  'r4',  'r5',  'r6',  'a6',  'r8',  ... 
 'a3',  'a4',  'a5',  'a7',  'r7',  'a8',  'a9',  'r9', 'a10', 'a11',  ... 
'a12', 'a13', 'a14', 'a15', 'a16', 'a17', 'a18', 'a19', 'a20', 'a21',  ... 
'a22', 'a23', 'a24', 'a25', 'a26', 'a27',  'f1',  'f2',  'f3',  'f4',  ... 
 'f5',  'f6',  'f7',  'f8',  'f9', 'f10', 'f11', 'f12',  'e1',  'e2',  ... 
 'e3',  'e4',  'e5',  'e6',  'e7',  'e8',  'e9', 'e10', 'e11', 'e12',  ... 
'e13', 'e14', 'e15', 'e16'
};


[~, N] = size(Labels);
Network = zeros(N, N);  

%% 
% 攻击层
Network(a1, r1) = 1;
Network(r1, [a2 a3 a4 a5 a6 a7 a8 a9]) = 1;
Network(a2, [r2 r3 r4 r5 r6]) = 1;
Network(r2, a3) = 1;
Network(r3, a4) = 1;
Network(r4, a5) = 1;
Network(r6, [a8 a9]) = 1;
Network(a6, r8) = 1;

Network(r8, a9) = 1;
Network([a3 a4 a5], r7) = 1;
Network(r7, a8) = 1;
Network([r1 r5], a7) = 1;
Network([a7 a8 a9], r9) = 1;
Network([r7 r9], [a10 a11 a12 a13 a14 a15]) = 1;
Network(r9, [a16 a17 a18 a19 a20 a21]) = 1;
Network([r7 r9], [a22 a23 a24 a25 a26 a27]) = 1;

%% 
% 功能层
Network([a10 a16 a22], [f1 f2]) = 1;
Network([a11 a17 a23], [f7 f8 f9]) = 1;
Network([a12 a18 a24], f6) = 1;
Network([a13 a19 a25], f5) = 1;
Network([a14 a20 a26], f4) = 1;
Network([a15 a21 a27], f3) = 1;
Network([f1 f2 f3 f7], f10) = 1;
Network([f1 f2 f3 f5 f8], f11) = 1;
Network([f4 f9], f12) = 1;

%%
% 事件层
Network(f10, [e1 e2]) = 1;
Network(f11, e3) = 1;
Network(f12, e4) = 1;
Network(f6, e8) = 1;
Network(e1, e5) = 1;
Network(e2, e7) = 1;
Network(e3, e9) = 1;
Network(e4, [e6 e9 e10]) = 1;
Network(e8, e9) = 1;
Network(e5, e11) = 1;
Network(e7, [e9 e14 e15]) = 1;
Network(e6, [e9 e11 e15 e14 e12 e16 e13 e10]) = 1;


%%
% 判断邻接矩阵是否为上三角
% R = 1;
% for i = 1:N
%     for j = 1:i
%         if Network(i,j) ~= 0
%             R = 0;
%         end
%     end
% end
% 
% Network
% 
% if R == 1
%     disp('OK!')
% else
%     disp('NO!')
% end

%%
discrete_nodes = 1:N;  
node_sizes= 2 * ones(1, N); 
bnet = mk_bnet(Network, node_sizes, 'names', Labels, 'discrete', discrete_nodes);  

%%
% 条件概率
bnet.CPD{ a1} = tabular_CPD(bnet,  a1, [0.99999999,0.00000001]);
bnet.CPD{ r1} = tabular_CPD(bnet,  r1, [0.99999999,0.00000100,0.00000001,0.99999900]);
bnet.CPD{ a2} = tabular_CPD(bnet,  a2, [0.99999999,0.50000000,0.00000001,0.50000000]);
bnet.CPD{ a6} = tabular_CPD(bnet,  a6, [0.99999999,0.90000000,0.00000001,0.10000000]);
bnet.CPD{ r2} = tabular_CPD(bnet,  r2, [0.99999999,0.40000000,0.00000001,0.60000000]);
bnet.CPD{ r3} = tabular_CPD(bnet,  r3, [0.99999999,0.40000000,0.00000001,0.60000000]);
bnet.CPD{ r4} = tabular_CPD(bnet,  r4, [0.99999999,0.40000000,0.00000001,0.60000000]);
bnet.CPD{ r6} = tabular_CPD(bnet,  r6, [0.99999999,0.40000000,0.00000001,0.60000000]);
bnet.CPD{ r5} = tabular_CPD(bnet,  r5, [0.99999999,0.40000000,0.00000001,0.60000000]);
bnet.CPD{ a3} = tabular_CPD(bnet,  a3, [0.99999999,0.99999999,0.35000000,0.35000000,0.00000001,0.00000001,0.65000000,0.65000000]);
bnet.CPD{ a4} = tabular_CPD(bnet,  a4, [0.99999999,0.99999999,0.35000000,0.35000000,0.00000001,0.00000001,0.65000000,0.65000000]);
bnet.CPD{ a5} = tabular_CPD(bnet,  a5, [0.99999999,0.99999999,0.35000000,0.35000000,0.00000001,0.00000001,0.65000000,0.65000000]);
bnet.CPD{ a7} = tabular_CPD(bnet,  a7, [0.99999999,0.99999999,0.35000000,0.35000000,0.00000001,0.00000001,0.65000000,0.65000000]);
bnet.CPD{ r8} = tabular_CPD(bnet,  r8, [0.99999999,0.20000000,0.00000001,0.80000000]);
bnet.CPD{ r7} = tabular_CPD(bnet,  r7, [0.99999999,0.90000000,0.90000000,0.50000000,0.80000000,0.50000000,0.50000000,0.10000000,0.00000001,0.10000000,0.10000000,0.50000000,0.20000000,0.50000000,0.50000000,0.90000000]);
bnet.CPD{ a8} = tabular_CPD(bnet,  a8, [0.99999999,0.99999999,0.99999999,0.99999999,0.99999999,0.99999999,0.99999999,0.20000000,0.00000001,0.00000001,0.00000001,0.00000001,0.00000001,0.00000001,0.00000001,0.80000000]);
bnet.CPD{ a9} = tabular_CPD(bnet,  a9, [0.99999999,0.99999999,0.99999999,0.99999999,0.99999999,0.99999999,0.99999999,0.20000000,0.00000001,0.00000001,0.00000001,0.00000001,0.00000001,0.00000001,0.00000001,0.80000000]);
bnet.CPD{ r9} = tabular_CPD(bnet,  r9, [0.99999999,0.90000000,0.90000000,0.50000000,0.90000000,0.50000000,0.50000000,0.10000000,0.00000001,0.10000000,0.10000000,0.50000000,0.10000000,0.50000000,0.50000000,0.90000000]);
bnet.CPD{a10} = tabular_CPD(bnet, a10, [0.99999999,0.70000000,0.70000000,0.70000000,0.00000001,0.30000000,0.30000000,0.30000000]);
bnet.CPD{a11} = tabular_CPD(bnet, a11, [0.99999999,0.70000000,0.70000000,0.70000000,0.00000001,0.30000000,0.30000000,0.30000000]);
bnet.CPD{a12} = tabular_CPD(bnet, a12, [0.99999999,0.70000000,0.70000000,0.70000000,0.00000001,0.30000000,0.30000000,0.30000000]);
bnet.CPD{a13} = tabular_CPD(bnet, a13, [0.99999999,0.70000000,0.70000000,0.70000000,0.00000001,0.30000000,0.30000000,0.30000000]);
bnet.CPD{a14} = tabular_CPD(bnet, a14, [0.99999999,0.70000000,0.70000000,0.70000000,0.00000001,0.30000000,0.30000000,0.30000000]);
bnet.CPD{a15} = tabular_CPD(bnet, a15, [0.99999999,0.70000000,0.70000000,0.70000000,0.00000001,0.30000000,0.30000000,0.30000000]);
bnet.CPD{a16} = tabular_CPD(bnet, a16, [0.99999999,0.70000000,0.00000001,0.30000000]);
bnet.CPD{a17} = tabular_CPD(bnet, a17, [0.99999999,0.70000000,0.00000001,0.30000000]);
bnet.CPD{a18} = tabular_CPD(bnet, a18, [0.99999999,0.70000000,0.00000001,0.30000000]);
bnet.CPD{a19} = tabular_CPD(bnet, a19, [0.99999999,0.70000000,0.00000001,0.30000000]);
bnet.CPD{a20} = tabular_CPD(bnet, a20, [0.99999999,0.70000000,0.00000001,0.30000000]);
bnet.CPD{a21} = tabular_CPD(bnet, a21, [0.99999999,0.70000000,0.00000001,0.30000000]);
bnet.CPD{a22} = tabular_CPD(bnet, a22, [0.99999999,0.70000000,0.70000000,0.70000000,0.00000001,0.30000000,0.30000000,0.30000000]);
bnet.CPD{a23} = tabular_CPD(bnet, a23, [0.99999999,0.70000000,0.70000000,0.70000000,0.00000001,0.30000000,0.30000000,0.30000000]);
bnet.CPD{a24} = tabular_CPD(bnet, a24, [0.99999999,0.70000000,0.70000000,0.70000000,0.00000001,0.30000000,0.30000000,0.30000000]);
bnet.CPD{a25} = tabular_CPD(bnet, a25, [0.99999999,0.70000000,0.70000000,0.70000000,0.00000001,0.30000000,0.30000000,0.30000000]);
bnet.CPD{a26} = tabular_CPD(bnet, a26, [0.99999999,0.70000000,0.70000000,0.70000000,0.00000001,0.30000000,0.30000000,0.30000000]);
bnet.CPD{a27} = tabular_CPD(bnet, a27, [0.99999999,0.70000000,0.70000000,0.70000000,0.00000001,0.30000000,0.30000000,0.30000000]);
bnet.CPD{ f1} = tabular_CPD(bnet,  f1, [0.99999999,0.70000000,0.70000000,0.40000000,0.70000000,0.40000000,0.40000000,0.11500000,0.00000001,0.30000000,0.30000000,0.60000000,0.30000000,0.60000000,0.60000000,0.88500000]);
bnet.CPD{ f2} = tabular_CPD(bnet,  f2, [0.99999999,0.70000000,0.70000000,0.40000000,0.70000000,0.40000000,0.40000000,0.11500000,0.00000001,0.30000000,0.30000000,0.60000000,0.30000000,0.60000000,0.60000000,0.88500000]);
bnet.CPD{ f3} = tabular_CPD(bnet,  f3, [0.99999999,0.70000000,0.70000000,0.40000000,0.70000000,0.40000000,0.40000000,0.11500000,0.00000001,0.30000000,0.30000000,0.60000000,0.30000000,0.60000000,0.60000000,0.88500000]);
bnet.CPD{ f4} = tabular_CPD(bnet,  f4, [0.99999999,0.70000000,0.70000000,0.40000000,0.70000000,0.40000000,0.40000000,0.11500000,0.00000001,0.30000000,0.30000000,0.60000000,0.30000000,0.60000000,0.60000000,0.88500000]);
bnet.CPD{ f5} = tabular_CPD(bnet,  f5, [0.99999999,0.70000000,0.70000000,0.40000000,0.70000000,0.40000000,0.40000000,0.11500000,0.00000001,0.30000000,0.30000000,0.60000000,0.30000000,0.60000000,0.60000000,0.88500000]);
bnet.CPD{ f6} = tabular_CPD(bnet,  f6, [0.99999999,0.70000000,0.70000000,0.40000000,0.70000000,0.40000000,0.40000000,0.11500000,0.00000001,0.30000000,0.30000000,0.60000000,0.30000000,0.60000000,0.60000000,0.88500000]);
bnet.CPD{ f7} = tabular_CPD(bnet,  f7, [0.99999999,0.70000000,0.70000000,0.40000000,0.70000000,0.40000000,0.40000000,0.11500000,0.00000001,0.30000000,0.30000000,0.60000000,0.30000000,0.60000000,0.60000000,0.88500000]);
bnet.CPD{ f8} = tabular_CPD(bnet,  f8, [0.99999999,0.70000000,0.70000000,0.40000000,0.70000000,0.40000000,0.40000000,0.11500000,0.00000001,0.30000000,0.30000000,0.60000000,0.30000000,0.60000000,0.60000000,0.88500000]);
bnet.CPD{ f9} = tabular_CPD(bnet,  f9, [0.99999999,0.70000000,0.70000000,0.40000000,0.70000000,0.40000000,0.40000000,0.11500000,0.00000001,0.30000000,0.30000000,0.60000000,0.30000000,0.60000000,0.60000000,0.88500000]);
bnet.CPD{f10} = tabular_CPD(bnet, f10, [0.99999999,0.99999999,0.99999998,0.50000000,0.99999997,0.54000000,0.34000000,0.14000000,0.99999998,0.67000000,0.64000000,0.32000000,0.45000000,0.14000000,0.15000000,0.14000000,0.00000001,0.00000001,0.00000002,0.50000000,0.00000003,0.46000000,0.66000000,0.86000000,0.00000002,0.33000000,0.36000000,0.68000000,0.55000000,0.86000000,0.85000000,0.86000000]);
bnet.CPD{f11} = tabular_CPD(bnet, f11, [0.99999999,0.99999998,0.99999997,0.80000000,0.99999994,0.99999950,0.99400000,0.92000000,0.99999996,0.70000000,0.55000000,0.68000000,0.60000000,0.59000000,0.69450000,0.44000000,0.99999997,0.99999991,0.80000000,0.64000000,0.77440000,0.54770000,0.65000000,0.44770000,0.75000000,0.54790000,0.53000000,0.13935000,0.97700000,0.23000000,0.35000000,0.16000000,0.00000001,0.00000002,0.00000003,0.20000000,0.00000006,0.00000050,0.00600000,0.08000000,0.00000004,0.30000000,0.45000000,0.32000000,0.40000000,0.41000000,0.30550000,0.56000000,0.00000003,0.00000009,0.20000000,0.36000000,0.22560000,0.45230000,0.35000000,0.55230000,0.25000000,0.45210000,0.47000000,0.86065000,0.02300000,0.77000000,0.65000000,0.84000000]);
bnet.CPD{f12} = tabular_CPD(bnet, f12, [0.99999999,0.50000000,0.50000000,0.20000000,0.00000001,0.50000000,0.50000000,0.80000000]);
bnet.CPD{ e1} = tabular_CPD(bnet,  e1, [0.99999997,0.50000001,0.00000003,0.49999999]);
bnet.CPD{ e2} = tabular_CPD(bnet,  e2, [0.99999997,0.50000001,0.00000003,0.49999999]);
bnet.CPD{ e3} = tabular_CPD(bnet,  e3, [0.99999997,0.13340000,0.00000003,0.86660000]);
bnet.CPD{ e4} = tabular_CPD(bnet,  e4, [0.99999999,0.32300000,0.00000001,0.67700000]);
bnet.CPD{ e8} = tabular_CPD(bnet,  e8, [0.99999998,0.10000000,0.00000002,0.90000000]);
bnet.CPD{ e5} = tabular_CPD(bnet,  e5, [0.99999999,0.74350000,0.00000001,0.25650000]);
bnet.CPD{ e7} = tabular_CPD(bnet,  e7, [0.99999999,0.44350000,0.00000001,0.55650000]);
bnet.CPD{ e6} = tabular_CPD(bnet,  e6, [0.99999999,0.74350000,0.00000001,0.25650000]);
bnet.CPD{e11} = tabular_CPD(bnet, e11, [1.00000000,0.40000000,0.10000000,0.02000000,0.00000000,0.60000000,0.90000000,0.98000000]);
bnet.CPD{e15} = tabular_CPD(bnet, e15, [1.00000000,0.10000000,0.20000000,0.10000000,0.00000000,0.90000000,0.80000000,0.90000000]);
bnet.CPD{e14} = tabular_CPD(bnet, e14, [1.00000000,0.10000000,0.40000000,0.10000000,0.00000000,0.90000000,0.60000000,0.90000000]);
bnet.CPD{e12} = tabular_CPD(bnet, e12, [0.99999997,0.05000000,0.00000003,0.95000000]);
bnet.CPD{e16} = tabular_CPD(bnet, e16, [0.99999997,0.10000000,0.00000003,0.90000000]);
bnet.CPD{e13} = tabular_CPD(bnet, e13, [0.99999997,0.20000000,0.00000003,0.80000000]);
bnet.CPD{e10} = tabular_CPD(bnet, e10, [1.00000000,0.50000000,0.00010000,0.00010000,0.00000000,0.50000000,0.99990000,0.99990000]);
bnet.CPD{ e9} = tabular_CPD(bnet,  e9, [1.00000000,0.70000000,0.70000000,0.50000000,0.00000001,0.00000001,0.00000001,0.00000001,0.70000000,0.60000000,0.60000000,0.45000000,0.00000001,0.00000001,0.00000001,0.00000001,0.40000000,0.35000000,0.35000000,0.40000000,0.00000001,0.00000001,0.00000001,0.00000001,0.35000000,0.30000000,0.30000000,0.20000000,0.00000001,0.00000001,0.00000001,0.00000001,0.00000000,0.30000000,0.30000000,0.50000000,0.99999999,0.99999999,0.99999999,0.99999999,0.30000000,0.40000000,0.40000000,0.55000000,0.99999999,0.99999999,0.99999999,0.99999999,0.60000000,0.65000000,0.65000000,0.60000000,0.99999999,0.99999999,0.99999999,0.99999999,0.65000000,0.70000000,0.70000000,0.80000000,0.99999999,0.99999999,0.99999999,0.99999999]);

%%
% 画图
% [x,y] = draw_graph(Network, Labels);

%%
engine=jtree_inf_engine(bnet);  
% evidence{a2}= True;

%%
% 动态过程
%       1    2    3    4    5    6    7    8    9   10
N = 10000;
E = zeros(1,N);
EvidentProportion = 0.1;

for i = 1:N
    if rand(1) > EvidentProportion
        % If won't generate a evidence
        E(1, i) = 0;
    else
        % If will generate a evidence
        e = round(rand(1,1)*size(Labels,2));
        while(e == 0)
            e = round(rand(1,1)*size(Labels,2));
        end
        if Labels{e}(1) ~= 'a'
            if rand(1) > 0.5
                e = -e;
            end
        end
        E(1, i) = e;
    end    
end

T = 1:size(E, 2);
CalcTime = zeros(1, size(E, 2));
MaxTime = max(T);
ESet = cell(1, N);
TimeThreshold = 150;
LastTime = 0;

pe9 = zeros(1,MaxTime);
pe10 = zeros(1,MaxTime);
pe11 = zeros(1,MaxTime);
pe12 = zeros(1,MaxTime);
pe13 = zeros(1,MaxTime);
pe14 = zeros(1,MaxTime);
pe15 = zeros(1,MaxTime);
pe16 = zeros(1,MaxTime);

h = waitbar(0, '正在计算，请稍后...');
for i = 1:MaxTime
    % Find evidence in evidence list E and time list T
    h = waitbar(i/MaxTime, h, ['正在计算，请稍后...',num2str(i/MaxTime*100),'%']);
    [Evidence, Time] = FindEvidence(E, T, i);

    % If T > T, remove all attack evidences from ESet
    if Time - LastTime > TimeThreshold
        for j = 1:N
            if Labels{j}(1) == 'a'
                ESet{j} = [];
            end
        end
    end
    
    % If there is no evidence
    if Evidence == 0;
        % Continue loop
    else
        if Evidence < 0;
        % If Evidence < 0, it represents that the evidence is function loss or
        % incidenc, and the broken function has been fixed up. Remove the evidence from the ESet.
            ESet{-Evidence} = [];
        else
        % If Evidence > 0, it means that we need to add the Evidence into ESet
            ESet{Evidence} = True;
            if Labels{Evidence}(1) == 'a'
                LastTime = Time;
            end            
        end
    end
           
    tic;
    [engine,loglik]=enter_evidence(engine,ESet);
    try
        m=marginal_nodes(engine, e9);  
        pe9(1,i) = m.T(2);
        m=marginal_nodes(engine, e10);  
        pe10(1,i) = m.T(2);
        m=marginal_nodes(engine, e11);  
        pe11(1,i) = m.T(2);
        m=marginal_nodes(engine, e12);  
        pe12(1,i) = m.T(2);
        m=marginal_nodes(engine, e13);  
        pe13(1,i) = m.T(2);
        m=marginal_nodes(engine, e14);  
        pe14(1,i) = m.T(2);
        m=marginal_nodes(engine, e15);  
        pe15(1,i) = m.T(2);
        m=marginal_nodes(engine, e16);  
        pe16(1,i) = m.T(2); 
    catch
    end
      
    CalcTime(1, i) = toc;
    
end

close(h);

t = mean(CalcTime)
save CalcTime.dat CalcTime -ascii;

figure
Density(CalcTime, 0.0001);