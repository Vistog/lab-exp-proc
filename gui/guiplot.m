function varargout = guiplot(varargin, kwargs, kwargsplt, figparam, axparamset, axparamfunc, axparamaxis, ...
    pltparam, roiparam, lgd, clb)
    arguments (Input, Repeating)
        varargin {mustBeA(varargin, {'numeric', 'cell'})}
    end
    arguments (Input)
        kwargs.dims (1,:) {mustBeInteger, mustBePositive} = []
        kwargs.ax {mustBeMember(kwargs.ax, {'1-1', '1-n'})} = '1-1'
        kwargs.roi {mustBeMember(kwargs.roi, {'1-1', '1-n'})} = '1-1'
        kwargsplt.plot char {mustBeMember(kwargsplt.plot, {'plot', 'imagesc', 'contour', 'contourf'})} = 'plot'
        kwargsplt.title {mustBeA(kwargsplt.title, {'char', 'string', 'cell'})} = ''
        kwargsplt.sgtitle (1,:) char = ''
        figparam.docked (1,1) logical = false
        figparam.arrangement {mustBeMember(figparam.arrangement, {'flow', 'vertical', 'horizontal'})} = 'flow'
        %% parameters for `set(ax, arg{:})`
        axparamset.xscale {mustBeMember(axparamset.xscale, {'linear', 'log'}), mustBeA(axparamset.xscale, {'char', 'cell'})} = 'linear'
        axparamset.yscale {mustBeMember(axparamset.yscale, {'linear', 'log'}), mustBeA(axparamset.yscale, {'char', 'cell'})} = 'linear'
        axparamset.zscale {mustBeMember(axparamset.zscale, {'linear', 'log'}), mustBeA(axparamset.zscale, {'char', 'cell'})} = 'linear'
        axparamset.colorscale {mustBeMember(axparamset.colorscale, {'linear', 'log'}), mustBeA(axparamset.colorscale, {'char', 'cell'})} = 'linear'
        axparamset.fontsize {mustBeInteger, mustBePositive} = 10
        %% parameters for `xlabel(ax, arg{:})` and so on
        axparamfunc.xlabel {mustBeA(axparamfunc.xlabel, {'char', 'cell'})} = ''
        axparamfunc.ylabel {mustBeA(axparamfunc.ylabel, {'char', 'cell'})} = ''
        axparamfunc.zlabel {mustBeA(axparamfunc.zlabel, {'char', 'cell'})} = ''
        axparamfunc.xlim {mustBeA(axparamfunc.xlim, {'char', 'double', 'cell'})} = 'auto'
        axparamfunc.ylim {mustBeA(axparamfunc.ylim, {'char', 'double', 'cell'})} = 'auto'
        axparamfunc.zlim {mustBeA(axparamfunc.zlim, {'char', 'double', 'cell'})} = 'auto'
        axparamfunc.clim {mustBeA(axparamfunc.clim, {'char', 'double', 'cell'})} = 'auto'
        axparamfunc.grid {mustBeMember(axparamfunc.grid, {'off', 'on'}), mustBeA(axparamfunc.grid, {'char', 'cell'})} = 'on'
        axparamfunc.box {mustBeMember(axparamfunc.box, {'off', 'on'}), mustBeA(axparamfunc.box, {'char', 'cell'})} = 'on'
        axparamfunc.pbaspect (1,3) {mustBePositive, mustBeNumeric} = [1, 1, 1]
        axparamfunc.hold {mustBeMember(axparamfunc.hold, {'off', 'on'}), mustBeA(axparamfunc.hold, {'char', 'cell'})} = 'off'
        axparamfunc.colormap {mustBeMember(axparamfunc.colormap, {'parula','turbo','hsv','hot','cool','spring','summer','autumn',...
            'winter','gray','bone','copper','pink','sky','abyss','jet','lines','colorcube','prism','flag','white'}), ...
            mustBeA(axparamfunc.colormap, {'char', 'cell'})} = 'turbo'
        %% parameters for `axis(ax, arg{:})`
        axparamaxis.aspect {mustBeMember(axparamaxis.aspect, {'auto', 'equal', 'image', 'square'}), mustBeA(axparamaxis.aspect, {'char', 'cell'})} = 'auto'
        axparamaxis.limits (1,:) {mustBeNumeric} = []
        %% parameters for `plot(ax, data{:}, arg{:})` and so on
        pltparam.marker {mustBeMember(pltparam.marker, {'none', 'o', 's', '<', '>', '^', 'd', '.'}), mustBeA(pltparam.marker, {'char', 'cell'})} = 'none'
        pltparam.linestyle {mustBeMember(pltparam.linestyle, {'none', '-', '--', '.-', ':'}), mustBeA(pltparam.linestyle, {'char', 'cell'})} = '-'
        pltparam.linewidth (1,1) double = 0.75
        pltparam.levels (1,:) double = 50
        pltparam.alphadata (1,1) double = 1
        %% ROI parameters
        roiparam.draw {mustBeMember(roiparam.draw, {'none', 'drawpoint', 'drawline', 'drawrectangle', 'drawpolygon', 'drawpolyline'}), ...
            mustBeA(roiparam.draw, {'char', 'cell'})} = 'none'
        roiparam.interaction {mustBeMember(roiparam.interaction, {'all', 'none', 'translate'}), ...
            mustBeA(roiparam.interaction, {'char', 'cell'})} = 'all'
        roiparam.position = []
        roiparam.number (1,:) cell = []
        roiparam.snap (1,:) logical = []
        roiparam.label (1,:) cell = []
        %% `legend` parameters
        lgd.legend (1,:) logical = false
        lgd.ltitle (1,:) {mustBeA(lgd.ltitle, {'char', 'string'})} = ''
        lgd.lorientation {mustBeMember(lgd.lorientation, {'vertical', 'horizontal'})} = 'vertical'
        lgd.llocation (1,:) char {mustBeMember(lgd.llocation, {'north','south','east','west','northeast','northwest','southeast','southwest','northoutside','southoutside','eastoutside','westoutside','northeastoutside','northwestoutside','southeastoutside','southwestoutside','best','bestoutside','layout','none'})} = 'best'
        lgd.displayname (1,:) {mustBeA(lgd.displayname, {'char', 'string', 'cell'})} = {}
        %% `colorbar` parmeters
        clb.colorbar (1,:) logical = false
        clb.clabel {mustBeA(clb.clabel, {'char', 'cell'})} = ''
        clb.corientation {mustBeMember(clb.corientation, {'vertical', 'horizontal'})} = 'vertical'
        clb.clocation (1,:) char {mustBeMember(clb.clocation, {'north','south','east','west','northeast','northwest','southeast','southwest','northoutside','southoutside','eastoutside','westoutside','northeastoutside','northwestoutside','southeastoutside','southwestoutside','bestoutside','layout','none'})} = 'eastoutside'
    end
    arguments (Output, Repeating)
        varargout
    end

    if isempty(kwargs.dims)
        switch kwargsplt.plot
            case 'plot'
                kwargs.dims = 1;
            otherwise
                kwargs.dims = [1, 2];
        end
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
    if isa(roiparam.interaction, 'char'); roiparam.interaction = {roiparam.interaction}; end
    if isempty(roiparam.snap); roiparam.snap = true(numel(roiparam.draw), 1); end
    if isempty(roiparam.number); roiparam.number = repmat({ones(1, numel(plts))}, numel(roiparam.draw), 1); end
    if isempty(roiparam.position); roiparam.position = repmat({cell(1, numel(plts))}, numel(roiparam.draw), 1); end

    assert(isequal(numel(roiparam.draw), numel(roiparam.position)), "`position` must be cell array size like `draw`")
    assert(isequal(numel(roiparam.draw), numel(roiparam.number)), "`number` must be cell array size like `draw`")

    n = numel(roiparam.draw);
    m = numel(axs);

    pltsc = plts;

    for i = 1:numel(roiparam.snap)
        if ~roiparam.snap(i); pltsc{i} = []; end
    end

    % axsa = repelem(axs, n, 1);
    % pltsa = repelem(pltsc, n, 1);
    % draws = repmat(roiparam.draw', m, 1);
    % number = num2cell([roiparam.number{:}])';
    % position = [roiparam.position{:}]';

    axsa = repelem(axs, n, 1)';
    pltsa = repelem(pltsc, n, 1)';
    draws = repmat(roiparam.draw', m, 1)';
    number = num2cell([roiparam.number{:}]);
    position = [roiparam.position{:}];


    % axsa = cellfun(@(x){x}, axsa, UniformOutput = false);
    % pltsa = cellfun(@(x){x}, pltsa, UniformOutput = false);
    % draws = cellfun(@(x){x}, draws, UniformOutput = false);
    % number = cellfun(@(x){x}, number, UniformOutput = false);
    % position = cellfun(@(x){x}, position, UniformOutput = false);
    % 
    % snaplab = cellfun(@(x){x}, repmat({'snap'}, n*m, 1), UniformOutput = false);
    % drawlab = cellfun(@(x){x}, repmat({'draw'}, n*m, 1), UniformOutput = false);
    % numberlab = cellfun(@(x){x}, repmat({'number'}, n*m, 1), UniformOutput = false);
    % poslab = cellfun(@(x){x}, repmat({'position'}, n*m, 1), UniformOutput = false);

    % new
    % args = {axsa, repmat({'snap'}, 1, n*m), pltsa, repmat({'draw'}, 1, n*m), ...
    %     draws, repmat({'number'}, 1, n*m), number, repmat({'position'}, 1, n*m), position};

    args = cat(1, axsa, repmat({'snap'}, 1, n*m), pltsa, repmat({'draw'}, 1, n*m), ...
        draws, repmat({'number'}, 1, n*m), number, repmat({'position'}, 1, n*m), position);

    % args = {axsa, repmat({'snap'}, n*m, 1), pltsa, repmat({'draw'}, n*m, 1), ...
    %     draws, repmat({'number'}, n*m, 1), number, repmat({'position'}, n*m, 1), position};
    % args = [args{:}];
    % 
    % args = cellfun(@(i) [args{i, :}], num2cell(1:size(args, 1)), UniformOutput = false);
    rois = cellfun(@(arg) guiroi(arg{:}), args{:}, UniformOutput = false);

    % old
    % rois = cellfun(@(ax, draw, number, snap, pos) guiroi(ax, draw = draw, number = number, snap = snap, position = pos), ...
    %     axsa, draws, number, pltsa, position, UniformOutput = false);
   
    varargout{1} = rois;

end