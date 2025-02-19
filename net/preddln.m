function varargout = preddln(network, data)
    %% Predict by deep neural network.

    arguments
        network {mustBeA(network, {'dlnetwork'})}
        data {mustBeA(data, {'matlab.io.datastore.CombinedDatastore'})}
    end

    X = readall(data.UnderlyingDatastores{1});
    T = readall(data.UnderlyingDatastores{2});
    Y = cell(numel(X), 1);
    for i = 1:numel(X)
        Y{i} = predict(network, X{i});
    end

    wrapper = @(x) squeeze(permute(reshape(cell2mat(x), [size(x{1}, 1), numel(x), size(x{1}, 2:ndims(x{1}))]), [1, (1:ndims(X{1}))+2, 2]));

    temp = {X; Y; T};
    varargout = cell(size(temp));
    temp = cellfun(wrapper, temp, UniformOutput = false);
    [varargout{:}] = deal(temp{:});
    
end