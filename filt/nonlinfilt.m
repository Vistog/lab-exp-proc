function varargout = nonlinfilt(varargin, kwargs)
    %% Filter data by multi dimensional sliding window and multi argument nonlinear kernel.
    % `varargin` is a positional argument corresponding to the data.
    %
    % `kernel` takes vector or multidimensional matrix that elements correspond to a sliding 
    % window size along each dimension of passed data. At multidimensional matrix notation the 
    % first N dimensions correspond to size filtered data and last N+1 dimension equals to the 
    % count of passed data dimensions. At vector notation there are two configuration: 
    % `kernel=[k1, ..., 0, ... kn]` means to disable padding data along according dimension by `0` 
    % position and slice data occur according to by specified `stride`; 
    % `kernel=[k1, ..., nan, ... kn]` means the total slice data by dimension with `nan` position. 
    % 
    % `stride` takes vector or multidimensional matrix that elements correspond to a 
    % sliding window stride along each dimension of passed data. Notations are similar to `kernel`. 
    % Specifying `stride=[s1, ..., nan, ... sn]` means middle slicing data by dimension with `nan` position. 
    % In case `kernel(i)=nan` and `stride(i)=nan` total slicing data along i-dimension without padding is occured.
    % 
    % `offset` takes vector or multidimensional matrix that elements correspond to a 
    % sliding window offset along each dimension of passed data. Notations
    % are similar to `kernel`. Default is zero vector.
    %
    % `shape` correspond to two filtering mode: `shape='same'` size of filtered data
    % is equal to passed data, ie sliding window crosses over data boundary; 
    % `shape='valid' sliding window moves inside data boundary, ie without padding.

    %% Examples:

    %% Filter the single 1D signal by sliding window with length 5 and stride 1.
    % x = rand(1,20);
    % y = nonlinfilt(x, method = @rms, kernel = 5);

    %% Filter the two 1D signals by sliding window with length 5 and stride 2.
    % x1 = rand(1,20);
    % x2 = rand(1,20);
    % y12 = nonlinfilt(x1, x2, method = @(x1,x2) rms(x1.*x2), kernel = 5, stride = 2);

    %% Filter the single 1D signal by sliding window with length 5, stride 1 and kernel function with two outputs.
    % x = rand(1,20);
    % y = nonlinfilt(x, method = @(x) [rms(x), mean(x)], kernel = 5);

    %% Filter the single 2D signal by sliding window with size [5, 2] and strides [1, 2].
    % x = rand(20);
    % y = nonlinfilt(x, method = @rms, kernel = [5, 2], stride = [1, 2]);

    %% Filter the two 2D signals by sliding window with size [5, 2], strides [1, 2] and kernel function with two outputs.
    % x1 = rand(20);
    % x2 = rand(20,20);
    % y12 = nonlinfilt(x1, x2, method = @(x1,x2) [rms(x1.*x2), mean(x1.*x2)], kernel = [5, 2], stride = [1, 2]);

    %% Filter the single 3D signal by sliding window with size [5, 2, 1] and strides [1, 1, 1].
    % x = rand(20,20,2);
    % y = nonlinfilt(x, method = @(x)rms(x(:)), kernel = [5, 2]);

    %% Filter the single 3D signal by sliding window with size [5, 2, 2] and strides [1, 1, 2].
    % x = rand(20,20,2);
    % y = nonlinfilt(x, method = @(x)rms(x(:)), kernel = [5, 5, nan], stride = [1, 1, nan]);

    %% Filter the two 3D signals by sliding window with sizes [5, 2, 2], [10, 10, 2] and strides [1, 1, 2], [1, 1, 2] for first and second signals consequently.
    % x1 = rand(20,20,2);
    % x2 = rand(20,20,2);
    % y = nonlinfilt(x1, x2, method = @(x1,x2)rms(x1(:)).*rms(x2(:)), kernel = {[5, 5, nan], [10, 10, nan]}, stride = [1, 1, nan]);

    arguments (Repeating, Input)
        varargin % data
    end

    arguments (Input)
        kwargs.method function_handle %% non-linear kernel function
        kwargs.kernel {mustBeA(kwargs.kernel, {'double', 'cell'})} = [] % window size
        kwargs.stride {mustBeA(kwargs.stride, {'double', 'cell'})} = [] % window stride
        kwargs.offset {mustBeA(kwargs.offset, {'double', 'cell'})} = [] % window offset
        kwargs.padval {mustBeA(kwargs.padval, {'double', 'char', 'string'})} = nan % padding value
        kwargs.shape (1,:) {mustBeMember(kwargs.shape, {'same', 'valid'})} = 'same' % subsection of the sliding window
        kwargs.verbose (1,1) logical = false % logger
        kwargs.cast (1,:) char {mustBeMember(kwargs.cast, {'int8', 'int16', 'int32', 'int64'})} = 'int64'
        kwargs.filtpass (1,1) logical = false;
        kwargs.ans {mustBeMember(kwargs.ans, {'array', 'cell'})} = 'array'
    end

    arguments (Repeating, Output)
        varargout
    end

    timer = tic;

    % evaluate size and dim of input data, flat vector data
    % sz = cell(1, nargin);
    for i = 1:nargin
        if isvector(varargin{i}); varargin{i} = varargin{i}(:); end
    end

    sz = cellfun(@size, varargin, UniformOutput = false);
    ndimsarg = cellfun(@ndims, varargin, UniformOutput = false);

    filtevalh = memoize(@filteval);

    [kwargs.kernel, kwargs.stride, kwargs.offset, outboundind, szf, filtpass] = filtevalh(sz, ndimsarg, ...
        kwargs.kernel, kwargs.stride, kwargs.offset, kwargs.shape, kwargs.cast, true);

    % padding of input data
    for i = 1:nargin
        for j = 1:size(outboundind{i}, 1)
            padsize = zeros(1, size(outboundind{i}, 1));
            padsize(j) = outboundind{i}(j, 1);
            varargin{i} = padarray(varargin{i}, padsize, kwargs.padval, 'pre');

            padsize = zeros(1, size(outboundind{i}, 1));
            padsize(j) = outboundind{i}(j, 2);
            varargin{i} = padarray(varargin{i}, padsize, kwargs.padval, 'post');
        end
    end

    nel = prod(szf);

    result = cell(nel, 1);

    parfor k = 1:nel
        dataslice = cell(1, numel(sz));
        for i = 1:numel(sz)   
            kernel = kwargs.kernel{i}(:,k);
            stride = kwargs.stride{i}(:,k);
            temporary = cell(1, numel(sz{i}));
            for j = 1:numel(sz{i})
                temporary{j} = stride(j) + (0:kernel(j));
            end
            dataslice{i} = varargin{i}(temporary{:});
        end
        result{k} = kwargs.method(dataslice{:}, k); 
    end

    switch kwargs.ans
        case 'array'
            result = cell2arr(result);

            if isvector(result)
                resh = szf;
            else
                resh = [size(result, 1:ndims(result)-1), szf];
            end
        
            result = reshape(result, resh);
    end

    if kwargs.verbose; disp(strcat("nonlinfilt: elapsed time is ", num2str(toc(timer)), " seconds")); end

    varargout{1} = result;
    varargout{2} = filtpass;

end