function varargout = fithist(kwargs)
%% Analytical approximation of one-dimensional statistical distribution by single or bi-mode distributions.
%% The function takes following arguments:
%   data:           [m×1 double]        - statistical data
%   x:              [n×1 double]        - statistical edges
%   y:              [n×1 double]        - statistical counts
%   norm:           [char array]        - type of statistics normalization
%   binedge:        [double]            - bins count or edge grid 
%   range:          [1×2 double]        - range to exclude data
%   normalize:      [char array]        - data normalization

%   distname:       [char array]        - approximation distribution name
%   solver:         [char array]        - execute fit or optimization: 'fit', 'opt'
%   objnorm:        [1×l double]        - norm order at calculation objective function
%   Aineq:          [p×l double]        - linear optimization inequality constrain matrix
%   bineq:          [l×1 double]        - linear optimization inequality constrain right side
%   Aeq:            [m×k double]        - linear optimization equality constrain matrix
%   beq:            [k×1 double]        - linear optimization equality constrain right side
%   nonlcon:        [funtion_handle]    - non-linear optimization constrain function
%   x0:             [1×k doule]         - inital parameters
%   lb:             [1×k doule]         - lower bound of parameters
%   ub:             [1×k doule]         - upper bpund of parameters
%   mb:             [1×2 doule]         - scale range of auto constrains
%   disp:           [1×1 logical]       - display optimization result and distribution parameters
%% The function returns following results:
%   f:              [1×1 cfit]          - fit object
%   modes:          [n×k double]        - approximate distribution modes assembled to column vector mapped by specific edges grid
%   edges:          [n×1 double]        - mesh of modes
%   coef:           [1×l double]        - solution of optimization problem
%   x:              [n×1 double]        - statistical edges
%   y:              [n×1 double]        - statistical counts
%% Examples:
%% 1. Fit raw data by two beta distributions with lower, upper and non-linear constrains:
% % gui
% rois = guihist(gca, data.dwdlf);
% probe = guigetdata(rois{1}, data.dwdlf, shape = 'flatten'); % get raw data
%
% % constrain function
% nonlcon = @(x) nonlconfitdist(x,distname='beta2',rmode1=[1e-4,6e-4],rvar1=[1e-8,1e-7],rmode2=[7e-4,5e-3],rvar2=[1e-7,1e-5]);
% % boundary constrains
% lb = [0, 1e-3, 0, 7.8, 6416, 1e-3, 1e-2, 0, 0, 0];
% ub = [2, 2e1, 1e-2, 7.8, 6416, 10, 2e1, 1e-2, 1e3, 1e4];
% % initial vector
% x0 = [1, 1, 1e-3, 5, 1e3, 1, 1, 3e-3, 10, 2e3];
% % fit
% [f, modes, edges, fval, x, y] = fithist(data = probe, distname = 'beta2', ...
%       objnorm = 2, nonlcon = nonlcon, x0 = x0, lb = lb, ub = ub, disp = true);
%% 2. Fit pdf curve by two skew normal distributions:
% % gui
% rois = guihist(gca, data.dwdlf);
% probe = guigetdata(rois{1}, data.dwdlf, shape = 'flatten'); % get raw data
% [y, x] = histcounts(probe, 'normalization', 'pdf');
% x = x(2:end);
%
% % fit
% [f, modes, edges, ~, ~, ~] = fithist(x = x, y = y, type = 'beta2');
    
    arguments
        %% data parameters
        kwargs.data double = []
        kwargs.x double = []
        kwargs.y double = []
        kwargs.norm (1,:) char {mustBeMember(kwargs.norm, {'count', 'pdf', 'probability', 'percentage', 'countdensity'})} = 'pdf'
        kwargs.binedge double = []
        kwargs.range double = []
        kwargs.normalize (1,:) char {mustBeMember(kwargs.normalize, {'none', 'zscore', 'norm', 'center', 'scale', 'range'})} = 'none'
        kwargs.pow (1,:) double = []
        %% optimization parameters
        kwargs.distname (1,:) char {mustBeMember(kwargs.distname, {'none', 'chi21', 'beta1', 'beta1l', 'beta2', 'beta2l', 'gamma1', 'gamma2', 'gumbel1', 'gumbel2'})} = 'gumbel2'
        kwargs.solver (1,:) char {mustBeMember(kwargs.solver, {'fit', 'opt'})} = 'fit'
        kwargs.objnorm double = 2
        kwargs.Aineq double = []
        kwargs.bineq double = []
        kwargs.Aeq double = []
        kwargs.beq double = []
        kwargs.nonlcon = []
        kwargs.x0 double = []
        kwargs.lb double = []
        kwargs.ub double = []
        kwargs.mb double = [0, 10];
        kwargs.verbose logical = false
    end

    warning off

    x = []; y = []; modes = [];

    % prepare fitting data
    if isempty(kwargs.data)
        if ~(isempty(kwargs.x) && isempty(kwargs.y))
            x = kwargs.x; y = kwargs.y;
        end
    else
        % normalization
        switch kwargs.normalize
            case 'none'
            otherwise
                kwargs.data = normalize(kwargs.data, kwargs.normalize);
        end

        if ~isempty(kwargs.pow); kwargs.data = kwargs.data.^kwargs.pow; end

        if isempty(kwargs.binedge)
            [y, x] = histcounts(kwargs.data, 'Normalization', kwargs.norm);
            edges = linspace(min(x), max(x), 1e3)';
        else
            [y, x] = histcounts(kwargs.data, kwargs.binedge, 'Normalization', kwargs.norm);
            edges = kwargs.binedge';
        end
        x = x(2:end);
    end

    % exclude & prepare data
    if ~isempty(kwargs.range)
        index = excludedata(x, y, 'range', kwargs.range);
        x = x(index); y = y(index); clear index;
    end
    [x, y] = prepareCurveData(x, y);

    % initialize optimization problem
    options = optimoptions('fmincon', 'Algorithm', 'interior-point', ...
        'MaxFunctionEvaluations', 1e4, 'MaxIterations', 3e3, ...
        'DiffMaxChange', 1e-4, 'Display', 'Off');
    problem = struct(options = options, solver = 'fmincon');

    if ~isempty(kwargs.Aineq); problem.Aineq = kwargs.Aineq; end
    if ~isempty(kwargs.bineq); problem.bineq = kwargs.bineq; end

    if ~isempty(kwargs.nonlcon); problem.nonlcon = kwargs.nonlcon; end

    if ~isempty(kwargs.x0); problem.x0 = kwargs.x0; end
    if ~isempty(kwargs.lb); problem.lb = kwargs.lb; end
    if ~isempty(kwargs.ub); problem.ub = kwargs.ub; end

    % selection fitting action
    switch kwargs.distname
        case 'chi21'
            fa = @(a, x) chi2pdf(x, a(1)); % approximation function
            coefi = 3; % initial vector
        case 'beta1'
            fa = @(a, x) a(1)*betapdf(x, a(2), a(3)); % approximation function
            fi = fitdist(kwargs.data, 'beta'); % initial appriximation
            coefi = [1, fi.a, fi.b]; % initial vector
        case 'beta1l'
            fa = @(a, x) a(1)*betapdf(x*a(2)-a(3), a(4), a(5)); % approximation function
            fi = fitdist(kwargs.data, 'beta'); % initial appriximation
            coefi = [1, 1, mode(kwargs.data), fi.a, fi.b]; % initial vector
        case 'beta2'
            f1 = @(a, x) a(1)*betapdf(x, a(2), a(3)); f1 = @(a, x) f1(a(1:3), x);
            f2 = @(a, x) a(1)*betapdf(x, a(2), a(3)); f2 = @(a, x) f2(a(4:end), x);
            fa = @(a, x) f1(a, x) + f2(a, x); % approximation function
            fi = fitdist(kwargs.data, 'beta'); % initial appriximation
            coefi = [1, fi.a, fi.b, 1, fi.a, fi.b]; % initial vector
        case 'beta2l'
            f1 = @(a, x) a(1)*betapdf(a(2)*x-a(3), a(4), a(5)); f1 = @(a, x) f1(a(1:5), x);
            f2 = @(a, x) a(1)*betapdf(a(2)*x-a(3), a(4), a(5)); f2 = @(a, x) f2(a(6:end), x);
            fa = @(a, x) f1(a, x) + f2(a, x); % approximation function
            fi = fitdist(kwargs.data, 'beta'); % initial appriximation
            coefi = [1, 1, mode(kwargs.data), fi.a, fi.b, 1, 1, mode(kwargs.data), fi.a, fi.b]; % initial vector
        case 'gamma1'
            fa = @(a, x) a(1)*gampdf(x, a(2), a(3)); % approximation function
            fi = fitdist(kwargs.data, 'gamma'); % initial appriximation    
            coefi = [1, fi.a, fi.b]; % initial vector
        case 'gamma2'
            f1 = @(a, x) a(1)*gampdf(x, a(2), a(3)); f1 = @(a, x) f1(a(1:3), x);
            f2 = @(a, x) a(1)*gampdf(x, a(2), a(3)); f2 = @(a, x) f2(a(4:end), x);
            fa = @(a, x) f1(a, x) + f2(a, x); % approximation function
            fi = fitdist(kwargs.data, 'gamma'); % initial appriximation
            coefi = [1, fi.a, fi.b, 1, fi.a, fi.b]; % initial vector
        case 'gumbel1'
            % fa = @(a, x) a(1)*evpdf(x, a(2), a(3)); % approximation function
            fa = @(a, x) a(1)/a(3)*exp(-(x-a(2))/a(3)-exp(-(x-a(2))/a(3)));
            fi = fitdist(kwargs.data, 'ev'); % initial appriximation
            coefi = [1, fi.mu, fi.sigma]; % initial vector
        case 'gumbel2'
            % f1 = @(a, x) a(1)*evpdf(x, a(2), a(3)); f1 = @(a, x) f1(a(1:3), x);
            % f2 = @(a, x) a(1)*evpdf(x, a(2), a(3)); f2 = @(a, x) f2(a(4:end), x);
            f1 = @(a, x) a(1)/a(3)*exp(-(x-a(2))/a(3)-exp(-(x-a(2))/a(3))); f1 = @(a, x) f1(a(1:3), x);
            f2 = @(a, x) a(1)/a(3)*exp(-(x-a(2))/a(3)-exp(-(x-a(2))/a(3))); f2 = @(a, x) f2(a(4:end), x);
            fa = @(a, x) f1(a, x) + f2(a, x); % approximation function
            fi = fitdist(kwargs.data, 'ev'); % initial appriximation
            coefi = [1, fi.mu, fi.sigma, 1, fi.mu, fi.sigma]; % initial vector 
    end

    try
        % define objective function
        fy = fit(x, y, 'linearinterp'); % linear interpolation of fitted curve
        fobj = @(a) norm(fa(a, x)-fy(x), kwargs.objnorm); % objective function
        problem.objective = fobj;
    
        % auto constraints
        if isempty(kwargs.x0); problem.x0 = coefi; end
        if isempty(kwargs.lb); problem.lb = kwargs.mb(1)*coefi; end
        if isempty(kwargs.ub); problem.ub = kwargs.mb(2)*coefi; end
    
        % solve problem
        [coef, ~] = fmincon(problem);
        f = @(x) fa(coef, x);
    
        % separate statistical modes
        if exist('f1', 'var') && exist('f2', 'var')
            modes(:, 1) = f1(coef, edges);
            modes(:, 2) = f2(coef, edges);
        else
            modes(:, 1) = fa(coef, edges);
        end
    
        if kwargs.verbose
            % show raw distribution parameters
            param = struct(mean = mean(kwargs.data), mode = mode(kwargs.data), variance = var(kwargs.data), ...
                skewness = skewness(kwargs.data), kurtosis = kurtosis(kwargs.data));
            tab = [param.mean; param.mode; param.variance; param.skewness; param.kurtosis];
            tab = array2table(tab, 'VariableNames', {'raw'}, 'RowName', {'mean', 'mode', 'variance', 'skewness', 'kurtosis'});
            disp(tab);

            % show optimization result
            tab = array2table(coef, 'VariableNames', split(num2str(1:size(coef, 2))), 'RowName', {'solution'});
            disp(tab);

            % show fitted distribution parameters
            distparam(coef, distname = kwargs.distname, disp = true);
        end
    catch
        f = []; modes = y; edges = x; coef = [];
    end

    % select outputs
    varargout{1} = f;
    varargout{2} = modes;
    varargout{3} = edges;
    varargout{4} = coef;

    if isempty(kwargs.x) && isempty(kwargs.y)
        varargout{5} = x;
        varargout{6} = y;
    end
end