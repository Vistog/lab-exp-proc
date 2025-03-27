function saf(path, kwargs, options)
    %%  Save all figures as `*.fig` and `*.{extension}`.
    arguments
        path {mustBeTextScalar} = []
        kwargs.resolution (1,1) = 300
        kwargs.extension (1,:) char = '.png'
        kwargs.obsidian {mustBeTextScalar}  = ""
        kwargs.units {mustBeMember(kwargs.units, {'pixels', 'normalized', 'inches', 'centimeters', 'points', 'characters'})} = 'centimeters'
        kwargs.size (1,:) double = [] 
        options.?matlab.ui.Figure
    end
    
    if ~isempty(path); try mkdir(path); catch; end; end

    if isfile(path)
        folder = fileparts(path);
    else
        folder = path;
    end

    options = namedargs2cell(options);

    figlist = findobj(allchild(0), 'flat', 'Type', 'figure');
    for iFig = 1:numel(figlist)
        fighandle = figlist(iFig);
        figname = strrep(string(datetime), ':', '-');
        filename = fullfile(folder, figname);
        pause(1)
        
        if ~isempty(kwargs.size)
            set(fighandle, WindowStyle = 'normal')
            pause(2)
            % set(fighandle, options{:});
            set(fighandle, Units = kwargs.units, Position = [0, 0, kwargs.size]);
        end

        exportgraphics(fighandle, strcat(filename, kwargs.extension), Resolution = kwargs.resolution)
        savefig(fighandle, strcat(filename, '.fig'));

        try
            obs_paster(kwargs.obsidian, strcat(figname, kwargs.extension));
        catch
        end

      set(fighandle, WindowStyle = 'docked')
    end
end

function obs_paster(filename, imagename, param)
    arguments
        filename {mustBeFile}
        imagename {mustBeTextScalar}
        param.size (1,:) {mustBeInteger, mustBeInRange(param.size, 1, 1000)} = 400
        param.pattern {mustBeTextScalar} = '%%'
        param.extenstion {mustBeTextScalar} = ".md"
    end

    [~, ~, extenstion] = fileparts(filename);
    if param.extenstion ~= extenstion; return; end

    [~, name] = fileparts(imagename);

    if isempty(param.size)
        imagename = strcat("![[",imagename,"]]"," ![[",name,".fig]]");
    else
        imagename = strcat("![[",imagename,"\|", num2str(param.size), "]]"," ![[",name,".fig]]");
    end
    text = string(fileread(filename));
    
    tf = contains(text, param.pattern);
    
    if tf
        % replace first matched
        index = strfind(text, param.pattern);
        text = char(text);
        text(index(1)+(0:numel(param.pattern)-1)) = '%#';
        text = string(text);

        text = strrep(text, '%#', imagename);
    else
        text = strcat(text, imagename);
    end
    
    writelines(text, filename)
end