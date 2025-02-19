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