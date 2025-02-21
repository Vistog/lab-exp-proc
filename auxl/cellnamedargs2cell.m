function r = cellnamedargs2cell(s)
    v = struct2cell(s);
    v = [v{:}];
    f = repelem(fieldnames(s), 1, size(v, 1))';
    r = cell(size(v, 1), 2*size(v, 2));
    r(:,1:2:end) = f;
    r(:,2:2:end) = v;
end