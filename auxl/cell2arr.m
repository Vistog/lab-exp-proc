function y = cell2arr(x)
    arguments (Input)
        x cell
    end
    arguments (Output)
        y double
    end
    
    wrapper = @(x) squeeze(permute(reshape(cell2mat(x), [size(x{1}, 1), numel(x), size(x{1}, 2:ndims(x{1}))]), [1, (1:ndims(x{1}))+2, 2]));
    
    y = wrapper(x);

end