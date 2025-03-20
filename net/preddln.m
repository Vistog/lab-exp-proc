function varargout = preddln(network, data)
    %% Predict by deep neural network.

    arguments
        network {mustBeA(network, {'dlnetwork'})}
        data {mustBeA(data, {'matlab.io.datastore.TransformedDatastore', 'matlab.io.datastore.CombinedDatastore'})}
    end

    switch class(data)
        case 'matlab.io.datastore.TransformedDatastore'
            temp = readall(data);
            X = temp(:,1);
            T = temp(:,2);
        case 'matlab.io.datastore.CombinedDatastore'
            X = readall(data.UnderlyingDatastores{1});
            T = readall(data.UnderlyingDatastores{2});    
    end
        
    Y = cell(numel(X), 1);
    for i = 1:numel(X)
        Y{i} = gather(predict(network, X{i}));
    end

    temp = {X; Y; T};
    varargout = cell(size(temp));
    temp = cellfun(@cell2arr, temp, UniformOutput = false);
    [varargout{:}] = deal(temp{:});

end