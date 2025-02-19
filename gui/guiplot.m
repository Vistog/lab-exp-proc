function varargout = guiplot(varargin, kwargs, kwargsplt, figparam, axparamset, axparamfunc, axparamaxis, ...
    pltparam, roiparam, lgd, clb)
    arguments (Input, Repeating)
        varargin {mustBeA(varargin, {'numeric', 'cell'})}
    end
    arguments (Input)
        kwargs.dims (1,:) double = 1
        kwargs.ax {mustBeMember(kwargs.ax, {'1-1', '1-n'})} = '1-1'
        kwargs.roi {mustBeMember(kwargs.roi, {'1-1', '1-n'})} = '1-1'
        kwargs.span (1,:) cell = {}
        kwargsplt.plot char {mustBeMember(kwargsplt.plot, {'plot', 'imagesc', 'contour', 'contourf'})} = 'plot'
        kwargsplt.title {mustBeA(kwargsplt.title, {'char', 'string', 'cell'})} = ''
        kwargsplt.sgtitle (1,:) char = ''
        figparam.docked (1,1) logical = false
        figparam.arrangement {mustBeMember(figparam.arrangement, {'flow', 'vertical', 'horizontal'})} = 'flow'
        %% parameters for `set(ax, arg{:})`
        axparamset.xscale {mustBeMember(axparamset.xscale, {'linear', 'log'})} = 'linear'
        axparamset.yscale {mustBeMember(axparamset.yscale, {'linear', 'log'})} = 'linear'
        axparamset.zscale {mustBeMember(axparamset.zscale, {'linear', 'log'})} = 'linear'
        axparamset.fontsize {mustBePositive} = 10
        %% parameters for `xlabel(ax, arg{:})` and so on
        axparamfunc.xlabel (1,:) char = []
        axparamfunc.ylabel (1,:) char = []
        axparamfunc.zlabel (1,:) char = []
        axparamfunc.xlim (1,:) {mustBeA(axparamfunc.xlim, {'char', 'double'})} = 'auto'
        axparamfunc.ylim (1,:) {mustBeA(axparamfunc.ylim, {'char', 'double'})} = 'auto'
        axparamfunc.zlim (1,:) {mustBeA(axparamfunc.zlim, {'char', 'double'})} = 'auto'
        axparamfunc.clim (1,:) {mustBeA(axparamfunc.clim, {'char', 'double'})} = 'auto'
        axparamfunc.grid {mustBeMember(axparamfunc.grid, {'off', 'on'})} = 'on'
        axparamfunc.box {mustBeMember(axparamfunc.box, {'off', 'on'})} = 'on'
        axparamfunc.pbaspect (1,3) {mustBePositive, mustBeNumeric} = [1, 1, 1]
        axparamfunc.hold {mustBeMember(axparamfunc.hold, {'off', 'on'})} = 'off'
        axparamfunc.colormap (1,:) char = 'turbo'
        %% parameters for `axis(ax, arg{:})`
        axparamaxis.aspect {mustBeMember(axparamaxis.aspect, {'auto', 'equal', 'image', 'square'})} = 'auto'
        axparamaxis.limits (1,:) {mustBeNumeric} = []
        %% parameters for `plot(ax, data{:}, arg{:})` and so on
        pltparam.marker {mustBeMember(pltparam.marker, {'none', 'o', 's', '<', '>', '^', 'd', '.'})} = 'none'
        pltparam.linestyle {mustBeMember(pltparam.linestyle, {'none', '-', '--', '.-', ':'})} = '-'
        pltparam.linewidth (1,1) double = 0.75
        pltparam.levels (1,:) double = 50
        pltparam.alphadata (1,1) double = 1
        %% ROI parameters
        roiparam.draw {mustBeMember(roiparam.draw, {'none', 'drawpoint', 'drawline', 'drawrectangle', 'drawpolygon', 'drawpolyline'}), ...
            mustBeA(roiparam.draw, {'char', 'cell'})} = 'none'
        roiparam.position (:,:) double = []
        roiparam.number (1,:) {mustBeInteger, mustBeGreaterThan(roiparam.number, 0)} = 1
        %% `legend` parameters
        lgd.legend (1,:) logical = false
        lgd.ltitle (1,:) {mustBeA(lgd.ltitle, {'char', 'string'})} = ''
        lgd.lorientation {mustBeMember(lgd.lorientation, {'vertical', 'horizontal'})} = 'vertical'
        lgd.llocation (1,:) char {mustBeMember(lgd.llocation, {'north','south','east','west','northeast','northwest','southeast','southwest','northoutside','southoutside','eastoutside','westoutside','northeastoutside','northwestoutside','southeastoutside','southwestoutside','best','bestoutside','layout','none'})} = 'best'
        lgd.displayname (1,:) {mustBeA(lgd.displayname, {'char', 'string', 'cell'})} = {}
        %% `colorbar` parmeters
        clb.colorbar (1,:) logical = false
        clb.clabel (1,:) char = []
        clb.corientation {mustBeMember(clb.corientation, {'vertical', 'horizontal'})} = 'vertical'
        clb.clocation (1,:) char {mustBeMember(clb.clocation, {'north','south','east','west','northeast','northwest','southeast','southwest','northoutside','southoutside','eastoutside','westoutside','northeastoutside','northwestoutside','southeastoutside','southwestoutside','bestoutside','layout','none'})} = 'eastoutside'
    end
    arguments (Output, Repeating)
        varargout
    end

    % parse data to cell array
    data = cell(numel(kwargs.dims) + 1, 1);
    [data{:}] = splitdatcell(varargin{:}, dims = kwargs.dims);

    if figparam.docked; figure(WindowStyle = 'docked'); else; clf; end
    tl = tiledlayout(figparam.arrangement);

    switch kwargs.ax
        case '1-n'
            kwargsplt.target = nexttile(tl);
        case '1-1'
            kwargsplt.target = tl;
    end

    % prepare and combine named argumetns for axis appeariance
    temp = cellfun(@namedargs2cell, {kwargsplt, axparamset, axparamfunc, axparamaxis, pltparam, lgd, clb}, UniformOutput = false);
    arg = {}; for i = 1:numel(temp); arg = cat(2, arg, temp{i}); end

    % plot data
    [plts, axs] = plotdatcell(data{:}, arg{:});

    % create roi instances
    if isa(roiparam.draw, 'char'); roiparam.draw = {roiparam.draw}; end
    rois = cell(numel(roiparam.draw), 1);
    for i = 1:numel(roiparam.draw)
        switch kwargs.roi
            case '1-n'
                ind = 1:numel(plts);
            case '1-1'
                ind = 1;
        end
        temp = roiparam;
        temp.draw = temp.draw{i};
        arg = namedargs2cell(temp);
        % rois{i} = cellfun(@(j) guiroi(axs{j}, arg{:}, snap = plts{j}), num2cell(ind), UniformOutput = false);
        rois{i} = cellfun(@(j) guiroi(axs{j}, arg{:}), num2cell(ind), UniformOutput = false);
    end
    
    varargout{1} = rois;

end