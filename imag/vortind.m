function result = vortind(u, w, kwargs)
    %% Process a vortex identification criteria

    arguments
        u double % first vector component
        w double % second vector component
        % type of vortex identification criteria
        kwargs.type (1,:) char {mustBeMember(kwargs.type, {'q', 'l2', 'd'})} = 'q'
        % differentiation kernel
        kwargs.diffilt (1,:) char {mustBeMember(kwargs.diffilt, {'sobel', '4ord', '4ordgauss', '2ord'})} = 'sobel'
        % threshold type
        kwargs.threshold (1,:) char {mustBeMember(kwargs.threshold, {'none', 'neg', 'pos'})} = 'none'
        kwargs.pow double = [] % raise result to the power
        kwargs.abs logical = false % absolute value of result
        kwargs.eigord double = 1 % eigenvalue odrer
        % prefilter kernel
        kwargs.prefilt (1,:) char {mustBeMember(kwargs.prefilt, {'none', 'average', 'gaussian', 'median', 'wiener'})} = 'gaussian'
        kwargs.prefiltker double = [3, 3] % prefilter kernel size
    end

    det2d = @(mat) squeeze(mat(1,1,:).*mat(2,2,:)-mat(1,2,:).*mat(2,1,:));
    tr2d = @(mat) squeeze(mat(1,1,:)+mat(2,2,:));

    sz = size(u);

    % velocity prefiltering
    u = imfilt(u, filt = kwargs.prefilt, filtker = kwargs.prefiltker);
    w = imfilt(w, filt = kwargs.prefilt, filtker = kwargs.prefiltker);

    % derivation
    Gx = difkernel(kwargs.diffilt); Gz = Gx';

    result = zeros([sz(1:2), prod(sz(3:end))]);

    for i = 1:prod(sz(3:end))

        dudx = imfilter(u(:,:,i), Gx); dudz = imfilter(u(:,:,i), Gz);
        dwdx = imfilter(w(:,:,i), Gx); dwdz = imfilter(w(:,:,i), Gz);
    
        % gradient prefiltering
        dudx = imfilt(dudx, filt = kwargs.prefilt, filtker = kwargs.prefiltker);
        dudz = imfilt(dudz, filt = kwargs.prefilt, filtker = kwargs.prefiltker);
        dwdx = imfilt(dwdx, filt = kwargs.prefilt, filtker = kwargs.prefiltker);
        dwdz = imfilt(dwdz, filt = kwargs.prefilt, filtker = kwargs.prefiltker);
    
        gradvel = cat(3, dudx, dudz, dwdx, dwdz);
        gradvel = reshape(gradvel, [sz(1:2), 2, 2]);
        gradvel = permute(gradvel, [ndims(gradvel)-1, ndims(gradvel), 1:ndims(gradvel)-2]);
           
        switch kwargs.type
            case 'q'
                symmat = 1/2*(gradvel+pagetranspose(gradvel));
                skewmat = 1/2*(gradvel-pagetranspose(gradvel));
                
                
                symmatdet = det2d(symmat);
                symmatdet = reshape(symmatdet, size(u));
            
                skewmatdet = det2d(skewmat);
                skewmatdet = reshape(skewmatdet, size(u));
            
                result(:,:,i) =skewmatdet.^2 - symmatdet.^2;
            case 'l2'
                symmat = 1/2*(gradvel+pagetranspose(gradvel));
                skewmat = 1/2*(gradvel-pagetranspose(gradvel));
    
                mat = pagemtimes(symmat, symmat) + pagemtimes(skewmat, skewmat);
        
                e = squeeze(pageeig(mat));
                result(:,:,i) = reshape(e(kwargs.eigord,:), sz(1:2));
            case 'd'              
                temp = tr2d(gradvel).^2-4*det2d(gradvel);
                result(:,:,i) = reshape(temp, sz(1:2));
        end

    end

    switch kwargs.threshold
        case 'neg'
            result(result<0) = 0;
        case 'pos'
            result(result>0) = 0;
    end

    if ~isempty(kwargs.pow)
        result = result.^kwargs.pow;
    end

    if kwargs.abs
        result = abs(result);
    end

end