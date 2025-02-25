function varargout = plotdatcell(varargin, kwargs, axparamset, axparamfunc, axparamaxis, pltparam, lgd, clb)
    %% Plot cell array data and customize axis appeariance.

    arguments (Input, Repeating)
        varargin cell {mustBeVector}
    end
    arguments (Input)
        kwargs.target (1,1) {mustBeA(kwargs.target, {'matlab.graphics.layout.TiledChartLayout', 'matlab.graphics.axis.Axes'})}
        kwargs.plot char {mustBeMember(kwargs.plot, {'plot', 'imagesc', 'contour', 'contourf', 'mesh'})} = 'plot'
        kwargs.title {mustBeA(kwargs.title, {'char', 'string', 'cell'})} = ''
        kwargs.sgtitle (1,:) char = ''
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
        clb.cExponent (1,:) double = []
        clb.cTickLabelFormat (1,:) char = '%0.1f'
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
        case 'mesh'
            listparam = {'linestyle', 'linewidth'};
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
    [~, h] = contourf(varargin{:}, options{:}); hold(varargin{1}, 'on')
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
        clb.cExponent (1,:) double = []
        clb.cTickLabelFormat (1,:) char = '%0.1f'
    end
    
    if clb.colorbar
        c = colorbar(ax, location = clb.clocation, orientation = clb.corientation);
        if ~isempty(clb.cExponent)
            c.Ruler.Exponent = clb.cExponent;
            c.Ruler.TickLabelFormat = clb.cTickLabelFormat;  
        end
        ylabel(c, clb.clabel)
    end
end