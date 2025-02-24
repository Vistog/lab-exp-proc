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
%% test combine permutation of cells array
clc
ax = gca;
s = {};
s.draw = {'drawpolygon', 'drawrectangle'};
s.plot = {'plot-1', 'plot-2'};
% s.snap = {{ax, ax}, {ax, ax}};
s.label = {'1', '2', '3'};
% s.number = {[1, 2], [1, 1]};
% s.number = {{1, 2}, {1, 1}};
s.position = {{rand(2,4), rand(2,4)}, {rand(2,4), rand(2,4)}, {rand(2,4), rand(2,4)}};


% s.number = num2cell([s.number{:}]);

v = struct2cell(s);

% for i = 1:numel(v)
%     if i == 2
%         t = v{i};
%         v{i} = [t{:}];
%     end
% end

res = cell(1, size(v,1));
[res{:}] = ndgrid(v{:});

res1 = cellfun(@(e) e(:), res, UniformOutput = false)
res1 = [res1{:}]

f = repelem(fieldnames(s), 1, size(res1, 1))';

res2 = cell(size(res1, 1), 2*size(res1, 2));
res2(:,1:2:end) = f;
res2(:,2:2:end) = res1;
%%
res3 = res2(1:7:end,:)

% a=res3(:,4)
% a{1}{1}-a{3}{1}
%%
clc
% test2(s, block={'draw', 'plot'})
tic
% test2({[1, 2]}, {'test1', 'test2', 'test3'}, s, block={1, 'draw', 'plot'})
test2({[1, 2]}, {'test1'}, s, block={1, 'draw', 'plot'})
toc
%%
clc
test2(s)

%% test
clc
s = {};
s.draw = {'drawpolygon', 'drawrectangle'};
s.plot = {'plot-1', 'plot-2'};
s.position = {{rand(2,4), rand(2,4)}, {rand(2,4), rand(2,4)}, {rand(2,4), rand(2,4)}};

% test2({[1, 2], [3, 4], [5, 4]}, {'test1'}, s, block = {'draw', 'plot'})
%%
clc
s = struct;
s.draw = {'drawpolygon', 'drawrectangle'};
cellnamedargs2cell({[1, 2], [3, 4]}, s, block = {1, 'draw'})
cellnamedargs2cell({[1, 2], [3, 4]}, s, block = {'draw'})
cellnamedargs2cell({[1, 2], [3, 4]}, s)
%%
clc
cellnamedargs2cell({[1, 2]}, s, block = {1})
%%
% draw draw1 var1 val1
% draw draw2 var1 val1
%%
function r = test(varargin)
    arguments (Input, Repeating)
        varargin
    end

    s = varargin{1};
    v = struct2cell(s);

    if isscalar(varargin)
        res = cell(1, size(v,1));
        [res{:}] = ndgrid(v{:});

        t = cellfun(@(e) e(:), res, UniformOutput = false);
        t = [t{:}];
        
        f = repelem(fieldnames(s), 1, size(t, 1))';
        
        r = cell(size(t, 1), 2*size(t, 2));
        r(:,1:2:end) = f;
        r(:,2:2:end) = t;

    else
        s1 = rmfield(s, varargin(2:end)); % ndgrid
        s2 = struct; % repelem
        for i = 2:nargin
            s2.(varargin{i}) = s.(varargin{i});
        end
        v1 = struct2cell(s1);
        v2 = struct2cell(s2);

        res = cell(1, size(v1,1));
        [res{:}] = ndgrid(v1{:});

        t1 = cellfun(@(e) e(:), res, UniformOutput = false);
        t1 = [t1{:}];
        
        f1 = repelem(fieldnames(s1), 1, size(t1, 1))';
        
        r1 = cell(size(t1, 1), 2*size(t1, 2));
        r1(:,1:2:end) = f1;
        r1(:,2:2:end) = t1;


        t2 = cellfun(@(e) e(:), v2, UniformOutput = false);
        t2 = [t2{:}];
        f2 = repelem(fieldnames(s2), 1, size(t2, 1))';

        r2 = cell(size(t2, 1), 2*size(t2, 2));
        r2(:,1:2:end) = f2;
        r2(:,2:2:end) = t2;

        repelem(r2, size(r1, 1), 1)

        r = cat(2, repelem(r2, size(r1, 1), 1), repelem(r1, size(r2, 1), 1));

    end

end

function r = test2(varargin, param)
    arguments (Input, Repeating)
        varargin 
    end
    arguments

        param.block (1,:) cell = {}
    end

    named = {};
    number = [];

    for val = param.block
        switch class(val{1})
            case 'double'
                number = [number, val{1}];
                temp = "var"+num2str(val{1});
            case 'char'
                temp = val;
        end
        named = [named, temp];
    end

    s = varargin{nargin};
    % append positional arguments to structure
    for i = 1:nargin-1
        s.("var"+num2str(i)) = varargin{i};
    end

    % combine structure elements
    r1 = {};
    try
        s1 = rmfield(s, named);
        v1 = struct2cell(s1);
        res = cell(1, size(v1,1));
        [res{:}] = ndgrid(v1{:});
    
        t1 = cellfun(@(e) e(:), res, UniformOutput = false);
        t1 = [t1{:}];
        
        f1 = repelem(fieldnames(s1), 1, size(t1, 1))';
        
        r1 = cell(size(t1, 1), 2*size(t1, 2));
        r1(:,1:2:end) = f1;
        r1(:,2:2:end) = t1;
    catch
    end

    % repeat structure elements
    r2 = {};
    try
        s2 = struct;
        for val = named; s2.(val{1}) = s.(val{1}); end
        v2 = struct2cell(s2);
        t2 = cellfun(@(e) e(:), v2, UniformOutput = false);
        t2 = [t2{:}];
        f2 = repelem(fieldnames(s2), 1, size(t2, 1))';
    
        r2 = cell(size(t2, 1), 2*size(t2, 2));
        r2(:,1:2:end) = f2;
        r2(:,2:2:end) = t2;
    catch
    end

    % finally cat
    if isempty(r1)
        r = r2;
        return;
    end
    if isempty(r2)
        r = r1;
    else
        r = cat(2, repelem(r2, size(r1, 1), 1), repelem(r1, size(r2, 1), 1));
    end

    % r = cat(2, r(:,end-2*(nargin-1)+1:end), r(:,1:end-2*(nargin-1)));

    % r(:,1:2:2*(nargin-1)) = [];

end