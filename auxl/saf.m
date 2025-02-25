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
        
        set(fighandle, WindowStyle = 'normal')
        pause(2)
        set(fighandle, options{:});
        
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
        param.size {mustBeInteger, mustBeInRange(param.size, 1, 1000)} = 500
        param.pattern {mustBeTextScalar} = '%%plt%%'
        param.extenstion {mustBeTextScalar} = ".md"
    end

    [~, ~, extenstion] = fileparts(filename);
    if param.extenstion ~= extenstion; return; end

    if isempty(param.size)
        imagename = strcat("![[",imagename,"]]");
    else
        imagename = strcat("![[",imagename,"|", num2str(param.size), "]]");
    end
    text = string(fileread(filename));
    
    tf = contains(text, param.pattern);
    
    if tf
        text = strrep(text, param.pattern, imagename);
    else
        text = strcat(text, imagename);
    end
    
    writelines(text, filename)
end