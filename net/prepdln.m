function varargout = prepdln(varargin, kwargs)
    %% Create dataset to train deep neural network.

    arguments (Repeating)
        varargin {mustBeA(varargin, {'double', 'categorical', 'logical'})}
    end

    arguments
        kwargs.IterationDimension (1,:) double = []
        kwargs.wrapper (1,:) cell = {}
        kwargs.suffle (1,1) logical = true
        kwargs.partition (1,:) cell = {}
        kwargs.transform (1,:) cell = {}
    end

    if isempty(kwargs.IterationDimension)
        for i = 1:nargin
            kwargs.IterationDimension(i) = ndims(varargin{i});
        end
    else
        assert(isequal(numel(kwargs.IterationDimension), nargin), "`IterationDimension` vectro must be have same size to data arguments")
    end

    sz = zeros(1, nargin); for i = 1:nargin; sz(i) = size(varargin{i}, kwargs.IterationDimension(i)); end

    if numel(unique(sz)) ~= 1; error(strcat("count of iteration ", jsonencode(sz)), " along given dimensional ", ...
            jsonencode(kwargs.IterationDimension), " must be same"); end
    
    if isempty(kwargs.partition); kwargs.partition{1} = 1:sz(1); end

    if isempty(kwargs.wrapper); kwargs.wrapper = repmat({[]}, 1, nargin); else
        assert(isequal(numel(kwargs.wrapper), nargin), "`wrapper` vector must be have same size to data arguments"); end

    if isempty(kwargs.transform); kwargs.transform = repmat({[]}, 1, nargin); else
        assert(isequal(numel(kwargs.transform), nargin), "`transform` vector must be have same size to data arguments"); end

    for i = 1:nargin
        if isempty(kwargs.wrapper{i})
            varargin{i} = arrayDatastore(varargin{i}, IterationDimension = kwargs.IterationDimension(i));
        else
            varargin{i} = arrayDatastore(kwargs.wrapper{i}(varargin{i}), IterationDimension = kwargs.IterationDimension(i));
        end
        if ~isempty(kwargs.transform{i}); varargin{i} = transform(varargin{i}, @(x)kwargs.transform{i}(x)); end
    end

    if isscalar(varargin); totalDataStore = varargin{1}; else; totalDataStore = combine(varargin{:}); end
    if kwargs.suffle; totalDataStore = shuffle(totalDataStore); end

    % create data partitions
    varargout = cell(1, numel(kwargs.partition));
    
    if numel(cell2mat(kwargs.partition)) == numel(kwargs.partition)
        partition = cell2mat(kwargs.partition);
        index = 1:sz(1);
        n = floor(partition*sz(1));
        n(end) = n(end) + sz(1) - sum(n);
        kwargs.partition = mat2cell(index, 1, n);
    end
    
    for i = 1:numel(kwargs.partition)
        varargout{i} = subset(totalDataStore, kwargs.partition{i}); 
    end
    
end