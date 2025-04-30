function [kernel, stride, offset, outboundind, szf, filtpass] = filteval(szarg, ndimsarg, ...
    kernel, stride, offset, shape, castt, isfiltpass)

    arguments
        szarg cell {mustBeVector}
        ndimsarg cell {mustBeVector}
        kernel {mustBeA(kernel, {'double', 'cell'})}
        stride {mustBeA(stride, {'double', 'cell'})}
        offset {mustBeA(offset, {'double', 'cell'})}
        shape 
        castt {mustBeMember(castt, {'int8', 'int16', 'int32', 'int64'})}
        isfiltpass logical {mustBeScalarOrEmpty}
    end

    nargin = numel(szarg);

    strideisvector = false(1, nargin);
    kernelisnan = cell(1, nargin);
    strideisnan = cell(1, nargin);

    % kernel validation
    if isempty(kernel); kernel = szarg; end
    if isa(kernel, 'double')
        if isvector(kernel)
            kernel = repmat({kernel}, 1, nargin);
        else
            kernel = {kernel};
        end
    end
    if nargin ~= numel(kernel); error('number of filter kernel must be equal one or correspond to number of filtering array'); end
    for i = 1:nargin; if isvector(kernel{i}); kernelisnan{i} = isnan(kernel{i}); end; end
    for i = 1:nargin; kernel{i} = cast(kernel{i}, castt); end

    % stride validation
    if isempty(stride)
        stride = cellfun(@(x) ones(size(x)), kernel, UniformOutput = false);
    end
    if isa(stride, 'double')
        if isvector(stride)
            stride = repmat({stride}, 1, nargin);
        else
            stride = {stride};
        end
    end
    if nargin ~= numel(stride); error('kernel and stride dimensions must be equal'); end
    for i = 1:nargin; if isvector(stride{i}); strideisnan{i} = isnan(stride{i}); end; end
    for i = 1:nargin; stride{i} = cast(stride{i}, castt); end

    % offset validation
    if isempty(offset)
        offset = cellfun(@(x) zeros(size(x)), kernel, UniformOutput = false);
    end
    if isa(offset, 'double')
        if isvector(offset)
            offset = repmat({offset}, 1, nargin);
        else
            offset = {offset};
        end
    end
    if nargin ~= numel(offset); error('kernel and offset dimensions must be equal'); end
    for i = 1:nargin; offset{i} = cast(offset{i}, castt); end

    % adjust filter parameters
    tempfunc = @(x) x*(x > 0);
    for i = 1:nargin
        if isvector(kernel{i})
            kernel{i} = padarray(kernel{i}, [0, tempfunc(ndimsarg{i}-numel(kernel{i}))], 0, 'post');
        end
        if isvector(stride{i})
            strideisvector(i) = true;
            stride{i} = padarray(stride{i}, [0, tempfunc(ndimsarg{i}-numel(stride{i}))], 1, 'post');
        end
        if isvector(offset{i})
            offset{i} = padarray(offset{i}, [0, tempfunc(ndimsarg{i}-numel(offset{i}))], 0, 'post');
        end
    end

    % evaluate a size of filtered data
    szf = cell(1, nargin);
    for i = 1:nargin
        if isvector(stride{i})
            for j = 1:numel(szarg{i})
                if isvector(kernel{i}) && shape == "valid"
                    temp = kernel{i}(j);
                    if temp ~= 0; temp = temp - 1; end
                    szf{i}(j) = numel(1:stride{i}(j):szarg{i}(j)-temp);
                else
                    szf{i}(j) = numel(1:stride{i}(j):szarg{i}(j));
                end
            end
            szf{i}(szf{i} == 0) = 1;
        else
            szf{i} = size(stride{i}, 1:ndims(stride{i})-1);
        end
    end
    
    % check a consistency of filtered data size
    szfnumel = zeros(1, numel(szf));
    for i = 1:numel(szf); szfnumel(i) = numel(szf{i}); end
    if numel(unique(szfnumel)) ~= 1; error(strcat("inconsistent dimensions of filter strides: ", jsonencode(szfnumel))); end
    szfval = zeros(numel(szf), szfnumel(1));
    for i = 1:numel(szf); szfval(i,:) = szf{i}; end
    if ~isvector(unique(szfval, 'row')); error(strcat("inconsistent grid of filter strides: ", jsonencode(szfval))); end
    szf = szf{1};

    % repeat vector elements according to size of filtered data 
    for i = 1:nargin
        if isvector(kernel{i})
            arg = cat(2, {shiftdim(kernel{i}, -numel(kernel{i}))}, num2cell(szf));
            kernel{i} = repmat(arg{:});
        end
        if isvector(stride{i})
            arg = cat(2, {shiftdim(stride{i}, -numel(stride{i}))}, num2cell(szf));
            stride{i} = repmat(arg{:});
        end
        if isvector(offset{i})
            arg = cat(2, {shiftdim(offset{i}, -numel(offset{i}))}, num2cell(szf));
            offset{i} = repmat(arg{:});
        end
    end

    % shift dimensition
    for i = 1:nargin
        kernel{i} = shiftdim(kernel{i}, ndims(kernel{i})-1);
        stride{i} = shiftdim(stride{i}, ndims(stride{i})-1);
        offset{i} = shiftdim(offset{i}, ndims(offset{i})-1);
    end

    % size validation
    for i = 1:nargin
        if ndimsarg{i} < size(kernel{i}, 1); error('kernel dimension number must not exceed data dimension number'); end
        if size(kernel{i}) ~= size(stride{i}); error('kernel and stride dimensions must be equal'); end
        if size(kernel{i}) ~= size(offset{i}); error('kernel and offset dimensions must be equal'); end
    end

    % cumulate strides
    for i = 1:nargin
        if strideisvector(i)
            for j = 1:size(stride{i}, 1)
                stride{i}(j,:) = reshape(cumsum(reshape(stride{i}(j,:), szf), j), [], 1)-stride{i}(j,1)+1;
            end
        else
            for j = 1:size(stride{i}, 1)
                stride{i}(j,:) = reshape(cumsum(reshape(stride{i}(j,:), szf), j), [], 1);
            end
        end
    end

    for i = 1:nargin
        if ~isempty(kernelisnan{i}); kernel{i}(kernelisnan{i},:) = szarg{i}(kernelisnan{i}); end
        if ~isempty(strideisnan{i})
            temp = mod(szarg{i}(strideisnan{i}), 2);
            if temp ~= 0; temp = 1; end
            stride{i}(strideisnan{i},:) = fix(szarg{i}(strideisnan{i})/2) + temp;
            if shape == "valid"
                temp = fix(kernel{i}/2);
                temp(temp~=0) = temp(temp~=0) - 1;
                stride{i}(strideisnan{i},:) = stride{i}(strideisnan{i},:) - temp(strideisnan{i},:);
            end
        end
    end

    % shift stride by half kernel
    if shape == "same"
        for i = 1:nargin
            temp = fix(kernel{i}/2);
            temp(temp~=0) = temp(temp~=0) - 1;
            stride{i} = stride{i} - temp;
        end
    end

    % substract unit from kernel
    for i = 1:nargin
        kernel{i} = kernel{i} - 1;
        kernel{i}(kernel{i}<0) = 0;
    end

    % evaluate outbound index slices
    outboundind = cell(1, nargin);
    for i = 1:nargin
        [minval, maxval] = bounds(reshape(cat(ndims(kernel{i})+1, zeros(size(kernel{i}),castt), ...
            kernel{i})+stride{i}+offset{i}, [numel(szarg{i}), prod(szf), 2]), [2, 3]);
        outboundind{i} = [minval, maxval];

        % evaluate paddings
        for j = 1:size(outboundind{i}, 1)
            if outboundind{i}(j, 1) < 1
                outboundind{i}(j, 1) = abs(outboundind{i}(j, 1)) + 1;
            else
                outboundind{i}(j, 1) = 0;
            end

            if outboundind{i}(j, 2) > szarg{i}(j)
                outboundind{i}(j, 2) = outboundind{i}(j, 2) - szarg{i}(j);
            else
                outboundind{i}(j, 2) = 0;
            end
        end
    end

    % shift origin indexes according to padding
    for i = 1:nargin
        stride{i} = stride{i} + offset{i} + outboundind{i}(:,1);
        offset{i} = [];
    end

    % evaluate filter passing
    filtpass = [];
    if isfiltpass
        masks = cellfun(@(x) zeros(x, castt), szarg, UniformOutput = false);

        % padding of input data
        for i = 1:nargin
            for j = 1:size(outboundind{i}, 1)
                padsize = zeros(1, size(outboundind{i}, 1));
                padsize(j) = outboundind{i}(j, 1);    
                masks{i} = padarray(masks{i}, padsize, 1, 'pre');
    
                padsize = zeros(1, size(outboundind{i}, 1));
                padsize(j) = outboundind{i}(j, 2);       
                masks{i} = padarray(masks{i}, padsize, 1, 'post');
            end
        end

        nel = prod(szf);

        filtpass = cell(nel, 1);
        parfor k = 1:nel
            dataslice = cell(1, numel(szarg));
            
            for i = 1:numel(szarg)   
                kernell = kernel{i}(:,k);
                stridel = stride{i}(:,k);
    
                temporary = cell(1, numel(szarg{i}));
                for j = 1:numel(szarg{i})
                    temporary{j} = stridel(j) + (0:kernell(j));
                end
    
                tempfunc = masks{i};
                tempfunc(temporary{:}) = 3;
                dataslice{i} = tempfunc;
            end

            filtpass{k} = dataslice;
        end

    end

end