classdef adaptiveDatastore
    
    properties
        folder
        ds
    end

    methods
        function obj = adaptiveDatastore(fnc, varargin, opts)
            arguments(Input)
                fnc
            end
            arguments (Input, Repeating)
                varargin
            end
            arguments (Input)
                opts.datastore {mustBeMember(opts.datastore, {'array', 'file'})} = 'array'
                opts.IterationDimension (:,1) cell = {}
            end

            switch opts.datastore
                case 'array'
                    if isempty(opts.IterationDimension); opts.IterationDimension = cellfun(@ndims, varargin, UniformOutput = false); end
                    dsa = cellfun(@(x, y) arrayDatastore(x, IterationDimension = y), varargin, opts.IterationDimension, ...
                        UniformOutput = false);
                    ds = combine(dsa{:});
                case 'file'
                    obj.folder = obj.makeStorage;
                    arrayFileDatastore(obj.folder, varargin{:}, IterationDimension = opts.IterationDimension)
                    ds = fileDatastore(obj.folder, ReadFcn = @obj.readStorage, FileExtensions = '.mat');
            end

            obj.ds = transform(ds, fnc);

        end

        function result = read(obj)
            result = read(obj.ds);
        end

        function y = readall(obj)
            y = readall(obj.ds, UseParallel = true);
        end

        function obj = writeall(obj)
            obj.folder = [obj.folder, obj.makeStorage];
            writeall(obj.ds, obj.folder(end), WriteFcn = @obj.writeStorage, UseParallel = false, ...
                FolderLayout = 'flatten')
        end

        function obj = delete(obj)
            cellfun(@obj.clearStorage, num2cell(obj.folder));
            % obj.clearStorage(obj.folder);
            % obj.folder = [];
            % obj.ds = [];
        end
        
    end

    methods (Access = private)
        function folder = makeStorage(~)
            folder = fullfile(tempdir, strrep(string(datetime), ':', '-'));
            if isfolder(folder)
                rmdir(folder, 's')
            end
            mkdir(folder)
        end

        function y = readStorage(~, x)
            y = struct2cell(load(x));
            y = y{:};
        end

        function writeStorage(~, data, writeInfo, ~)
            save(writeInfo.SuggestedOutputName, 'data')
        end

        function clearStorage(~, folder)
            if isfolder(folder)
                rmdir(folder,'s')
            end
        end
    end

end