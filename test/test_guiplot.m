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
test(s, 'draw')

%%
getfield(s, 'draw', 'label')
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
    else
        s1 = rmfield(s, varargin(2:end));
        s2 = struct;
        for i = 2:nargin
            s2.(varargin{i}) = s.(varargin{i});
        end
        v1 = struct2cell(s1);
        v2 = struct2cell(s2);
    end

    t = cellfun(@(e) e(:), res, UniformOutput = false);
    t = [t{:}];
    
    f = repelem(fieldnames(s), 1, size(t, 1))';
    
    r = cell(size(t, 1), 2*size(t, 2));
    r(:,1:2:end) = f;
    r(:,2:2:end) = t;
end