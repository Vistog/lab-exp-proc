function [y0, z0, x0] = findoffsetcta(filename, kwargs)
    %% Find offset vertical coordinates by specified velocity isoline level.

    arguments (Input)
        filename (1,:) {mustBeA(filename , {'char', 'string'})}
        kwargs.isovel (1,1) double = 10
        kwargs.y (:,:) double = []
        kwargs.yi (1,:) double = []
        kwargs.ratio (1,:) double = []
        kwargs.tonan (1,1) logical = true
        kwargs.numch (1,1) double = 3
        kwargs.show (1,1) logical = true
        kwargs.reshape (1,:) double = []
        kwargs.scandelimiter (1,:) char = '\t'
        kwargs.scanseparator (1,:) char = ','
    end

    if isfolder(filename)
        data = loadcta(filename,numch=kwargs.numch);
    else
        if isfile(filename)
            data.scan = table2array(readtable(filename, Delimiter = kwargs.scandelimiter, DecimalSeparator = kwargs.scanseparator));
        else
            error('scan file isn`t found')
        end
    end

    if isempty(kwargs.y)
        y = data.scan(:,3);
    else
        y = kwargs.y;
    end

    x = data.scan(:,1);
    z = data.scan(:,2);
    v = data.scan(:,4);

    if isempty(kwargs.reshape)
        kwargs.reshape = [numel(unique(y)), numel(unique(z)), numel(unique(x))];
    end

    x = reshape(x,kwargs.reshape);
    z = reshape(z,kwargs.reshape);
    y = reshape(y,kwargs.reshape);
    v = reshape(v,kwargs.reshape);

    % exclude near wall points
    v = v(:,:); y = y(:,:);
    index = cumsum(v >= kwargs.isovel, 1) == repmat((1:size(v,1))',1,size(v,2));
    v(~index) = nan;
    y(~index) = nan;

    % piecewise linear interpolation
    vf = {}; yf = {};
    for i = 1:size(v, 2)
        [y0,v0] = prepareCurveData(y(:,i),v(:,i));
        vf{i} = fit(y0,v0,'linearinterp');
    end

    % find offset
    if isempty(kwargs.yi)
        kwargs.yi = zeros(1,numel(vf));
    end
    
    y0 = zeros(1,numel(vf));
    if ~isempty(kwargs.ratio)
        kwargs.isovel = kwargs.ratio*max(v,[],1,'omitmissing');
    else
        kwargs.isovel = repmat(kwargs.isovel,1,numel(vf));
    end
    for i = 1:numel(vf)
        y0(i) = fsolve(@(x)vf{i}(x)-kwargs.isovel(i),kwargs.yi(i));
    end
    y0 = round(y0);
    z0 = z(1,:);
    x0 = x(1,:);

    % show results
    if kwargs.show
        figure(WindowStyle='docked'); hold on; grid on; box on; axis square;
        plt = plot(y,v,'.-');
        l = legend(plt, "("+string(split(num2str(x0)))+";"+string(split(num2str(z0)))+")"); 
        title(l,'(x,z), count',FontWeight='normal');
        scatter(y0,kwargs.isovel,'filled',DisplayName='isovel')
        xlabel('y, conut'); ylabel('u, m/s');
    end 

end