function result = nonlinfilt(method, varargin, kwargs, opts, pool)
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

    arguments (Input)
        method function_handle %% non-linear kernel function
    end

    arguments (Repeating, Input)
        varargin % data
    end

    arguments (Input)
        kwargs.kernel {mustBeA(kwargs.kernel, {'double', 'cell'})} = [] % window size
        kwargs.stride {mustBeA(kwargs.stride, {'double', 'cell'})} = [] % window stride
        kwargs.offset {mustBeA(kwargs.offset, {'double', 'cell'})} = [] % window offset
        kwargs.cast (1,:) char {mustBeMember(kwargs.cast, {'int8', 'int16', 'int32', 'int64'})} = 'int32'
        kwargs.padval {mustBeA(kwargs.padval, {'double', 'char', 'string', 'logical', 'cell'})} = nan % padding value
        opts.verbose logical {mustBeScalarOrEmpty} = false % logger
        opts.ans {mustBeMember(opts.ans, {'array', 'cell', 'filedatastore'})} = 'array'
        opts.paral (1,1) logical = true
        opts.usefiledatastore (1, 1) logical = false
        opts.useparallel (1,1) logical = false
        opts.extract {mustBeMember(opts.extract, {'readall', 'writeall'})} = 'readall'
        pool.poolsize = {16, 16}
        pool.resources {mustBeA(pool.resources, {'cell'}), mustBeMember(pool.resources, {'Processes', 'Threads'})} = {'Processes', 'Threads'}
    end

    arguments (Output)
        result
    end

    % prepare pool
    poolarg = cellfun(@(x,y){x,y}, pool.resources, pool.poolsize, UniformOutput = false);
    poolswitcher(poolarg{1}{:});

    timer = tic;

    if opts.usefiledatastore
        opts.folder = makefolder();
        opts.method = method;
        method = @(varargin) matfilesaveker(opts.folder, varargin{:});
    end

    % flat vector data
    for i = 1:numel(varargin)
        if isvector(varargin{i}); varargin{i} = varargin{i}(:); end
    end

    % evaluate size
    kwargs.szarg = cellfun(@size, varargin, UniformOutput = false);

    % evaluate filter passing
    filtevalh = memoize(@filteval);
    arg = namedargs2cell(kwargs);
    kwargs = filtevalh(arg{:});

    % append padding
    for i = 1:kwargs.narg
        for j = 1:size(kwargs.outbound{i}, 1)
            padsize = zeros(1, size(kwargs.outbound{i}, 1));
            padsize(j) = kwargs.outbound{i}(j, 1);
            varargin{i} = padarray(varargin{i}, padsize, kwargs.padval{i}{j}, 'pre');

            padsize = zeros(1, size(kwargs.outbound{i}, 1));
            padsize(j) = kwargs.outbound{i}(j, 2);
            varargin{i} = padarray(varargin{i}, padsize, kwargs.padval{i}{j}, 'post');
        end
    end

    % parallel iteration
    result = cell(kwargs.numfilt, 1);
    parfor k = 1:kwargs.numfilt
        dataslice = cell(1, kwargs.narg);
        for i = 1:kwargs.narg   
            kernel = kwargs.kernel{i}(:,k);
            stride = kwargs.stride{i}(:,k);
            temporary = cell(1, kwargs.ndimsarg{i});
            for j = 1:kwargs.ndimsarg{i}
                temporary{j} = stride(j) + (0:kernel(j));
            end
            dataslice{i} = varargin{i}(temporary{:});
        end
        result{k} = method(dataslice{:}, k); 
    end

    if opts.usefiledatastore
        dsf = fileDatastore(opts.folder, FileExtensions = '.mat', ReadFcn = @ReadFcn);
        dsft = transform(dsf, @(x) {opts.method(x{1:end-1}), x{end}});

        poolswitcher(poolarg{2}{:});

        switch opts.extract
            case 'readall'
                result = readall(dsft, UseParallel = opts.useparallel);
            case 'writeall'
                opts.foldersec = makefolder();
                writeall(dsft, opts.foldersec, WriteFcn = @WriteFcn, ...
                    UseParallel = opts.useparallel, ...
                    FolderLayout = 'flatten');

                dsfr = fileDatastore(opts.foldersec, FileExtensions = '.mat', ReadFcn = @ReadFcn);
                dsft = transform(dsfr, @(x) {x{1:end-1}, x{end}});

                result = readall(dsft, UseParallel = opts.useparallel);

                % remove datastore folders
                cellfun(@(x) rmdir(x, 's'), dsfr.Folders);
        end
        
        % remove datastore folders
        cellfun(@(x) rmdir(x, 's'), dsf.Folders);
        
        % soft filter iteration
        [~, index] = sort(cell2mat(result(:, end)));
        result = result(index, 1:end-1);
    end

    switch opts.ans
        case 'array'
            tf = isscalar(result);
            result = cell2arr(result);
            if isvector(result)
                shape = kwargs.szfilt;
            else
                szout = size(result);
                if ~tf; szout = szout(1:end-1); end
                shape = [szout, kwargs.szfilt];
            end
            result = squeeze(reshape(result, shape));
    end

    if opts.verbose; disp(strcat("nonlinfilt: elapsed time is ", num2str(toc(timer)), " seconds")); end

end

function y = matfilesaveker(folder, varargin)
    save(fullfile(folder, strcat('part', num2str(varargin{end}), '.mat')), 'varargin')
    y = [];
end

function y = ReadFcn(x)
    y = struct2cell(load(x));
    y = y{:};
end

function WriteFcn(data, writeInfo, ~)
    save(writeInfo.SuggestedOutputName, 'data')
end

function folder = makefolder()
    folder = fullfile(tempdir, strrep(string(datetime), ':', '-'));
    if isfolder(folder); rmdir(folder, 's'); end
    mkdir(folder)
end