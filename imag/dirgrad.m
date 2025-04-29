function varargout = dirgrad(u, w, angle, kwargs)
%% Process a directed gradient of multidimensional data

%% Example
% 1. Calculate a longitudinal derivative of transverse velocity component in rotated coordinate system
% data.dwdl = dirgrad(data.u, data.w, deg2rad(-22), component = 'dwdl', diffilt = '4ord');
    
    arguments
        u double % first vector component
        w double % second vector component
        angle % double angle rotation, [rad]
        % returned directed derivatives
        kwargs.component (1,:) char {mustBeMember(kwargs.component, {'dudl', 'dudn', 'dwdl', 'dwdn', 'all'})} = 'dwdl'
        % differentiation kernel
        kwargs.diffilt (1,:) char {mustBeMember(kwargs.diffilt, {'sobel', '4ord', '4ordgauss', '2ord'})} = 'sobel'
        % prefilter kernel
        kwargs.prefilt (1,:) char {mustBeMember(kwargs.prefilt, {'none', 'average', 'gaussian', 'median', 'wiener'})} = 'gaussian'
        kwargs.prefiltker double = [3, 3] % prefilter kernel size
        % optional
        kwargs.paral (1,1) logical = true
    end

    mat = [cos(angle)^2, cos(angle)*sin(angle), cos(angle)*sin(angle), sin(angle)^2; ...
        -cos(angle)*sin(angle), cos(angle)^2, -sin(angle)^2, cos(angle)*sin(angle); ...
        -cos(angle)*sin(angle), -sin(angle)^2, cos(angle)^2, cos(angle)*sin(angle); ...
        sin(angle)^2, -cos(angle)*sin(angle), -cos(angle)*sin(angle), cos(angle)^2];

    sz = size(u);

    Gx = difkernel(kwargs.diffilt); Gz = Gx';

    % velocity prefiltering
    u = imfilt(u, filt = kwargs.prefilt, filtker = kwargs.prefiltker, paral = kwargs.paral);
    w = imfilt(w, filt = kwargs.prefilt, filtker = kwargs.prefiltker, paral = kwargs.paral);

    switch kwargs.component
        case 'dudl'
            ind = 1;
        case 'dudn'
            ind = 2;
        case 'dwdl'
            ind = 3;
        case 'dwdn'
            ind = 4;
        case 'all'
            ind = 1:4;
    end

    % allocate
    vr = zeros(prod(sz(1:2)), numel(ind), prod(sz(3:end)));

    for i = 1:prod(sz(3:end))
        % derivation
        dudx = imfilter(u(:,:,i), Gx); dudz = imfilter(u(:,:,i), Gz);
        dwdx = imfilter(w(:,:,i), Gx); dwdz = imfilter(w(:,:,i), Gz);
        % rotate
        temp = [dudx(:), dudz(:), dwdx(:), dwdz(:)]*mat;
        % slice
        temp = temp(:, ind);
        vr(:, :, i) = temp;
    end
        
    if isscalar(ind)
        varargout{1} = reshape(vr(:, 1, :), sz);
    else
        varargout = cell(4, 1);
        [varargout{:}] = cellfun(@(n) reshape(vr(:, n, :), sz), num2cell(ind), UniformOutput = false);
    end

end