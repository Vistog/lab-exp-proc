function r = cellnamedargs2cell(varargin, param)
    arguments (Input, Repeating)
        varargin 
    end
    arguments

        param.block (1,:) cell = {}
    end

    named = {};
    number = [];

    for val = param.block
        switch class(val{1})
            case 'double'
                number = [number, val{1}];
                temp = "var"+num2str(val{1});
            case 'char'
                temp = val;
        end
        named = [named, temp];
    end

    s = varargin{nargin};
    % append positional arguments to structure
    for i = 1:nargin-1
        s.("var"+num2str(i)) = varargin{i};
    end

    % combine structure elements
    r1 = {};
    try
        s1 = rmfield(s, named);
        v1 = struct2cell(s1);
        res = cell(1, size(v1,1));
        [res{:}] = ndgrid(v1{:});
    
        t1 = cellfun(@(e) e(:), res, UniformOutput = false);
        t1 = [t1{:}];
        
        f1 = repelem(fieldnames(s1), 1, size(t1, 1))';
        
        r1 = cell(size(t1, 1), 2*size(t1, 2));
        r1(:,1:2:end) = f1;
        r1(:,2:2:end) = t1;

        % r1 = r1(:,end-2*(nargin-1)+1:end);
    catch
    end

    % repeat structure elements
    r2 = {};
    try
        s2 = struct;
        for val = named; s2.(val{1}) = s.(val{1}); end
        v2 = struct2cell(s2);
        t2 = cellfun(@(e) e(:), v2, UniformOutput = false);
        t2 = [t2{:}];
        f2 = repelem(fieldnames(s2), 1, size(t2, 1))';
    
        r2 = cell(size(t2, 1), 2*size(t2, 2));
        r2(:,1:2:end) = f2;
        r2(:,2:2:end) = t2;
    catch
    end

    % finally cat
    if isempty(r1)
        r = r2;
        return;
    end
    if isempty(r2)
        r = r1;
    else
        r = cat(2, repelem(r2, size(r1, 1), 1), repelem(r1, size(r2, 1), 1));
    end

    % r = cat(2, r(:,end-2*(nargin-1)+1:end), r(:,1:end-2*(nargin-1)));

    % r(:,1:2:2*(nargin-1)) = [];

end