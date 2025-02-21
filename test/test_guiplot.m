%% 1D data, 1D plot, single tile
guiplot(rand(35,1), ax = '1-n', dims = 1)
%% 2D data, 1D plot, single tile
guiplot(rand(35,5), ax = '1-n', dims = 1)
%% 3D data, 1D plot, single tile
guiplot(rand(35,5,3), ax = '1-n', dims = 1)
%% 2D data, 1D plot, multi tile
guiplot(rand(35,35), ax = '1-1', dims = 1:2, plot = 'contourf', hold = 'off', ...
    aspect = 'image', linestyle = 'none', grid = 'on')
%% 2D data, 2D plot
guiplot(rand(35,25,3), ax = '1-1', dims = 1:2, plot = 'imagesc', aspect = 'image')
%% 1D data, 1D plot, single tile, plot, drawpoint
guiplot(rand(35,1), ax = '1-n', dims = 1, draw = 'drawpoint', number = 2)
%% 2D data, 2D plot, single tile, imagesc, drawpoint
guiplot(rand(35,100), ax = '1-n', dims = 1:2, ...
    plot = 'imagesc', draw = 'drawpoint', aspect = 'image', hold='off')
%% 2D data, 2D plot, single tile, contourf, drawpoint
guiplot(rand(35,100), ax = '1-n', dims = 1:2, ...
    plot = 'contourf', draw = 'drawpoint', aspect = 'image')
%% 1D data, 1D plot, single tile, plot, drawline
guiplot(rand(35,1), ax = '1-n', dims = 1, draw = 'drawline')
%% 2D data, 2D plot, single tile, imagesc, drawline
guiplot(rand(35,100), ax = '1-n', dims = 1:2, ...
    plot = 'imagesc', draw = 'drawline')
%% 2D data, 2D plot, single tile, contourf, drawline
guiplot(rand(35,100), ax = '1-n', dims = 1:2, ...
    plot = 'contourf', draw = 'drawline')
%% 1D data, 1D plot, single tile, drawrectangle
guiplot(rand(35,1), ax = '1-n', dims = 1, draw = 'drawrectangle')
%% 2D data, 2D plot, single tile, imagesc, drawrectangle
guiplot(rand(35,100), ax = '1-n', dims = 1:2, ...
    plot = 'imagesc', draw = 'drawrectangle')
%% 2D data, 2D plot, single tile, contourf, drawrectangle
guiplot(rand(35,100), ax = '1-n', dims = 1:2, ...
    plot = 'contourf', draw = 'drawrectangle')
%% 1D data, 1D plot, single tile, drawpolygon
guiplot(rand(35,1), ax = '1-n', dims = 1, draw = 'drawpolygon')
%% 2D data, 2D plot, single tile, imagesc, drawpolygon
guiplot(rand(35,100), ax = '1-n', dims = 1:2, ...
    plot = 'imagesc', draw = 'drawpolygon')
%% 2D data, 2D plot, single tile, contourf, drawpolygon
guiplot(rand(35,100), ax = '1-n', dims = 1:2, ...
    plot = 'contourf', draw = 'drawpolygon')
%% 1D data, 1D plot, single tile, drawpolyline
guiplot(rand(35,1), ax = '1-n', dims = 1, draw = 'drawpolyline')
%% 2D data, 2D plot, single tile, imagesc, drawpolyline
guiplot(rand(35,100), ax = '1-n', dims = 1:2, ...
    plot = 'imagesc', draw = 'drawpolyline')
%% 2D data, 2D plot, single tile, contourf, drawpolyline
guiplot(rand(35,100), ax = '1-n', dims = 1:2, ...
    plot = 'contourf', draw = 'drawpolyline')
%% 1D data, 2D plot, multi tile, plot, drawpoint, single roi
guiplot(rand(35,2), ax = '1-1', dims = 1, plot = 'plot', draw = 'drawpoint', roi = '1-1')
%% 1D data, 2D plot, multi tile, plot, drawpoint, multi roi
guiplot(rand(35,2), ax = '1-1', dims = 1, plot = 'plot', draw = 'drawpoint', roi = '1-n')
%% 1D data, 2D plot, single tile, plot, drawpoint, multi roi
guiplot(rand(35,2), ax = '1-n', dims = 1, plot = 'plot', draw = 'drawpoint', roi = '1-n')
%% 2D data, 2D plot, single tile, contourf, drawpoint
guiplot(rand(35,100), ax = '1-n', dims = 1:2, ...
    plot = 'contourf', draw = {'drawpoint', 'drawline'}, aspect = 'image', linestyle = 'none')
%% 2D data, 2D plot, single tile, merge contourf, drawpolygon, snap on
[x1, y1] = meshgrid(linspace(0, 1, 10));
z1 = sin(10*x1-5*y1);
[x2, y2] = meshgrid(linspace(0.5, 1.5, 10));
z2 = sin(10*x2-5*y2);
guiplot({x1,x2}, {y1,y2}, {z1,z2}, ax = '1-n', ...
    plot = 'contourf', draw = {'drawpolygon', 'drawrectangle', 'drawpoint'}, aspect = 'image', linestyle = 'none', ...
    roi = '1-1', number = {[1, 1], [1, 1], [1, 1]})
%% 2D data, 2D plot, single tile, merge contourf, drawpolygon, snap on, position
[x1, y1] = meshgrid(linspace(0, 1, 10));
z1 = sin(10*x1-5*y1);
[x2, y2] = meshgrid(linspace(0.5, 1.5, 10));
z2 = sin(10*x2-5*y2);
guiplot({x1,x2}, {y1,y2}, {z1,z2}, ax = '1-n', ...
    plot = 'contourf', draw = {'drawrectangle'}, aspect = 'image', linestyle = 'none', ...
    roi = '1-1', number = {[3, 1]}, position={{[0.2,0.2,0.1,0.1], [0.6,0.6,0.1,0.1]}})
%% 2D data, 2D plot, single tile, merge contourf, drawpolygon, snap on, position
[x1, y1] = meshgrid(linspace(0, 1, 10));
z1 = sin(10*x1-5*y1);
[x2, y2] = meshgrid(linspace(0.5, 1.5, 10));
z2 = sin(10*x2-5*y2);
guiplot({x1,x2}, {y1,y2}, {z1,z2}, ax = '1-1', ...
    plot = 'contourf', draw = {'drawrectangle'}, aspect = 'image', linestyle = 'none', ...
    roi = '1-1', number = {[3, 1]}, position={{[0.2,0.2,0.1,0.1], [0.6,0.6,0.1,0.1]}},...
    xlabel='x, mm', ylabel={'y1, mm', 'y2, mm'})
%%
clc
ax = gca;
args = {{ax, 'plot', [1, 2], 'test', [1, 2]}, {ax, 'plot', [4, 5], 'test', [1, 2]}};
% cellfun(@test, args{:})
test(args{:})
%%

cellfun(@test, args{:})
%%
clc
args = {{ax; ax}, {'plot'; 'plot1'}, {[1, 2]; [3, 4]}};
% args = {{{'plot'}; {'plot1'}}, {[1, 2]; [3, 4]}};

temp = [args{:}];

temp2 = {};

for i  = 1:size(temp, 1)
    for j = 1:size(temp, 2)
        temp2{i}{j} = temp{i,j};
    end
end

%%
res = cell(1, numel(temp));

[res{:}] = temp{:}
%%
temp2 = {};

% for i  = 1:size(temp, 1); temp2{i} = [temp{i,:}]; end

temp2 = cellfun(@(i) [temp{i, :}], num2cell(1:2), UniformOutput = false)
%%
cellfun(@test, temp2{:}, UniformOutput = false)
%%
cellfun(@test, temp{:,:})
%%
clc
res = cell(1, size(temp, 2));
[res{:}] = deal(temp{1,:})
[res{:}] = deal(temp{2,:})

%%
r = cellfun(@(i) deal(temp{i,:}), num2cell(1:size(temp, 2)))
%%
clc
arg1 = {ax, ax, ax};
arg2 = {'plot', 'plot', 'plot'};
arg3 = {[1, 2], [1, 2], [1, 2]};

args = {{ax; ax}, {'plot0'; 'plot1'}, {[1, 2]; [3, 4]}};

% cellfun(@(a1,a2,a3) a1, arg1, arg2, arg3, UniformOutput = false)
% cellfun(@(varargin) test(varargin{:}), arg1, arg2, arg3, UniformOutput = false);

cellfun(@(varargin) test(varargin{:}), args{:}, UniformOutput = false)
%%
DC = @(C) deal(C{:});
makevtext = @(varargin) DC(cellfun(@(V) vtext(V), varargin, 'uniform',0 ));
%%
DC(arg1)
%%
clc
h = @(varargin) deal(varargin{:});

h(arg1, arg2)
%%
clc
roiparam.draw = {'t1', 't2'}';
roiparam.pow = {[1, 2], [3, 4]}';

struct2pointwisecell(roiparam)
%%

s = struct2cell(roiparam);
s = [s{:}];

f = repelem(fieldnames(roiparam), 1, size(s, 1))';
[f,s];


r = cellfun(@(a,b) {a,b}, f, s, UniformOutput=false);
r = [r{:}];
reshape(r', 2, 4)'
%%
temp = {}
for i = 1:numel(roiparam.draw)
    
end
%%
clc
% r = cellfun(@(varargin) deal(varargin{1,:}), f, s, UniformOutput=false)
r = cellfun(@(a, b) deal(a{:,1}, b{:, 1}), f{:}, s{:}, UniformOutput=false)
%%
clc
a={f{:};s{:}}
reshape(a, 4, 2)
%%
a = struct(f1 = {1, 2}, f2 = {3, 4})
%%
roiparam.draw = {'t1', 't2'}';
roiparam.pow = {[1, 2], [3, 4]}';
roiparam.num = {{1,2}, {6,7}}';

s = struct2cell(roiparam);
s = [s{:}];

s2 = s(:,3);
s2 = [s2{:}]'


f = repelem(fieldnames(roiparam), 1, size(s, 1))';

a = cell(size(s,1), 2*size(s,2));
a(:,1:2:end) = f;
a(:,2:2:end) = s;

a

% [a(:,1:2:end), a(:,2:2:end)] = deal(f, s);

%%
clc
s = struct2cell(roiparam);
res = cell(1,size(s,1))
[res{:}] = ndgrid(s{:})

%%
res = cellfun(@(x) ndgrid(x{:}), {s}, UniformOutput=true)

function r= struct2pointwisecell(s)
    v = struct2cell(s);
    v = [v{:}];
    f = repelem(fieldnames(s), 1, size(v, 1))';
    r = cell(size(v, 1), 2*size(v, 2));
    r(:,1:2:end) = f;
    r(:,2:2:end) = v;
end
%% 
function test1(arg)
    arguments (Repeating)
        arg 
    end
end
%%
function test(varargin, kwargs)
    arguments (Repeating)
        varargin
    end
    arguments
        kwargs.test = []
    end
    disp("/n")
    disp(varargin)
    disp(kwargs)
end