function r = cellnamedargs2cell2(varargin, param)
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

    sz = [];

    s = varargin{nargin};
    % append positional arguments to structure
    for i = 1:nargin-1
        s.("var"+num2str(i)) = varargin{i};
    end

    if ~isscalar(unique(sz)); error(''); end

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
    catch
    end

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

    % stack
    if ~isempty(named) & ~isscalar(varargin)
        r3 = repelem(shiftdim(r2', -1), size(r1, 1), 1, 1);
        r4 = repelem(r1, 1, 1, size(r3, 3));
        r5 = [r3,r4];
    
        r6 = [];
        for i = 1:size(r5,3)
            r6 = cat(1, r6, r5(:,:,i));
        end

        r = r6;
    else
        if isempty(r1); r = r2; end
        if isempty(r2); r = r1; end
    end

    % replace cell of varargin to first place
    l = r(1,1:2:end);
    varn = [];
    vari = [];
    for i = 1:numel(l)
        if contains(l{i}, "var")
            vari = [vari, i];
            varn = [varn, str2num(erase(l{i}, "var"))];
        end
    end
    [~, i] = sort(varn);
    vari = 2*vari(i)-1;
    vari = repelem(vari, 1, 2);
    vari(2:2:end) = vari(2:2:end) + 1;

    indn = 1:size(r, 2);
    indn(vari) = [];

    r = [r(:,vari(2:2:end)), r(:,indn)];

end