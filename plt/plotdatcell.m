function varargout = plotdatcell(varargin, kwargs, axparamset, axparamfunc, axparamaxis, pltparam, lgd, clb)
    %% Plot cell array data and customize axis appeariance.

    arguments (Input, Repeating)
        varargin cell {mustBeVector}
    end
    arguments (Input)
        kwargs.target (1,1) {mustBeA(kwargs.target, {'matlab.graphics.layout.TiledChartLayout', 'matlab.graphics.axis.Axes'})}
        kwargs.plot char {mustBeMember(kwargs.plot, {'plot', 'imagesc', 'contour', 'contourf'})} = 'plot'
        kwargs.title {mustBeA(kwargs.title, {'char', 'string', 'cell'})} = ''
        kwargs.sgtitle (1,:) char = ''
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

    % prepare axis parameters for @set
    axparamset = namedargs2cell(axparamset);

    % prepare axis properties for @axis
    axparamaxis = struct2cell(axparamaxis);
    axparamaxis = axparamaxis(~cellfun('isempty', axparamaxis));

    % stack handles and argument lists
    axfuncname = cellfun(@str2func, cat(1, 'axis', fieldnames(axparamfunc), 'set'), ...
        UniformOutput = false);
    axfuncarg = cat(1, {axparamaxis}, cellfun(@(c){{c}}, struct2cell(axparamfunc)), {axparamset});
    axfunc = {axfuncname, axfuncarg};

    % crate axis cell array
    switch class(kwargs.target)
        case 'matlab.graphics.layout.TiledChartLayout'
            axs = cellfun(@nexttile, num2cell(1:numel(varargin{1}))', UniformOutput = false);
        case 'matlab.graphics.axis.Axes'
            axs = repmat({kwargs.target}, numel(varargin{1}), 1);
    end

    % parse data and plot appearance for specified plot type
    switch kwargs.plot
        case 'plot'
            listparam = {'linestyle', 'linewidth', 'marker'};
            cellfun(@(ax) hold(ax, 'on'), axs)
        case 'contourf'
            listparam = {'linestyle', 'linewidth', 'levels'};
        case 'imagesc'
            listparam = {'alphadata'};
            varargin = {varargin{nargin}};
    end
    pltparamarg = cell2struct(cellfun(@(field) pltparam.(field), listparam, UniformOutput = false), listparam, 2);
    % prepare plot appearance
    pltparamarg = namedargs2cell(pltparamarg);
    for i = 1:numel(pltparamarg); pltparamarg{i} = {repmat({pltparamarg{i}}, numel(varargin{1}), 1)}; end

    % transform to handle
    if kwargs.plot == "contourf"; kwargs.plot = "contourfc"; end
    kwargs.plot = str2func(kwargs.plot);

    % plot data
    data = cat(2, varargin, pltparamarg{:});
    plts = cellfun(kwargs.plot, axs, data{:}, UniformOutput = false);
    
    % set an axis appearance
    cellfun(@(ax) cellfun(@(func, arg) func(ax, arg{:}), axfunc{:}), axs)

    if ~isa(kwargs.title, 'cell'); kwargs.title = repmat({kwargs.title}, numel(axs), 1); end
    if isrow(kwargs.title); kwargs.title = kwargs.title'; end
    cellfun(@(ax, label) title(ax, label, 'FontWeight', 'Normal'), axs, kwargs.title)

    sgtitle(kwargs.sgtitle)

    % set legend parameters
    lgdaparam = repmat({namedargs2cell(lgd)}, numel(axs), 1);
    cellfun(@(ax, arg) setLegend(ax, arg{:}), axs, lgdaparam)

    % set colorbar parameters
    clbaparam = repmat({namedargs2cell(clb)}, numel(axs), 1);
    cellfun(@(ax, arg) setColorbar(ax, arg{:}), axs, clbaparam)

    varargout{1} = plts;
    varargout{2} = axs;

end

function h = contourfc(varargin, options)
    arguments (Input, Repeating)
        varargin
    end
    arguments (Input)
        options.?matlab.graphics.chart.primitive.Contour
        options.levels (1,:) double = 25
    end
    arguments (Output)
        h matlab.graphics.chart.primitive.Contour
    end
    varargin{nargin + 1} = options.levels;
    options = rmfield(options, 'levels');
    options = namedargs2cell(options);
    [~, h] = contourf(varargin{:}, options{:});
end

function setLegend(ax, lgd)
    arguments
        ax matlab.graphics.axis.Axes  
        lgd.legend (1,:) logical = false
        lgd.ltitle (1,:) {mustBeA(lgd.ltitle, {'char', 'string'})} = ''
        lgd.lorientation {mustBeMember(lgd.lorientation, {'vertical', 'horizontal'})} = 'vertical'
        lgd.llocation (1,:) char {mustBeMember(lgd.llocation, {'north','south','east','west','northeast','northwest','southeast','southwest','northoutside','southoutside','eastoutside','westoutside','northeastoutside','northwestoutside','southeastoutside','southwestoutside','best','bestoutside','layout','none'})} = 'best'
        lgd.displayname (1,:) {mustBeA(lgd.displayname, {'char', 'string', 'cell'})} = {}
    end
    if lgd.legend
        l = legend(ax, lgd.displayname, Location = lgd.llocation, Orientation = lgd.lorientation); 
        title(l, lgd.ltitle, FontWeight = 'normal')
    end
end

function setColorbar(ax, clb)
    arguments
        ax matlab.graphics.axis.Axes  
        clb.colorbar (1,:) logical = false
        clb.clabel (1,:) char = []
        clb.corientation {mustBeMember(clb.corientation, {'vertical', 'horizontal'})} = 'vertical'
        clb.clocation (1,:) char {mustBeMember(clb.clocation, {'north','south','east','west','northeast','northwest','southeast','southwest','northoutside','southoutside','eastoutside','westoutside','northeastoutside','northwestoutside','southeastoutside','southwestoutside','bestoutside','layout','none'})} = 'eastoutside'
    end
    
    if clb.colorbar
        c = colorbar(ax, location = clb.clocation, orientation = clb.corientation);
        ylabel(c, clb.clabel)
    end
end