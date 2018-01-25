mainFolder = 'C:\Users\cis\Documents\Lung cancer\XYZ';
savefolder = 'C:\Users\cis\Documents\Lung cancer\PNG1'
subdirs = dir(mainFolder);
subdirs(~[subdirs.isdir]) = [];
%And this filters out the parent and current directory '.' and '..'
tf = ismember( {subdirs.name}, {'.', '..'});
subdirs(tf) = [];
numberOfFolders = length(subdirs);
x = [];
i =0;
k = 'k'
J = 'J'
L = 'L'
y = 'y'
for K = 1: numberOfFolders
    k
    thissubdir = subdirs(K).name;
    mkdir(savefolder, thissubdir)
    subdirpath = [mainFolder '\' thissubdir];
    newfolderpath = [savefolder '\' thissubdir]
    subsubdir =  dir(subdirpath)
    subsubdir(~[subsubdir.isdir]) = [];
    tf = ismember( {subsubdir.name}, {'.', '..'});
    subsubdir(tf) = [];
    numberOfsubFolders = length(subsubdir);
    
    for J= 1: numberOfsubFolders
        J
        thissubsubdir = subsubdir(J).name;
        subsubdirpath = [subdirpath '\' thissubsubdir];
        mkdir(newfolderpath , thissubsubdir)
        subnewfolderpath = [newfolderpath '\' thissubsubdir]
        subsubsubdir =  dir(subsubdirpath)
        subsubsubdir(~[subsubsubdir.isdir]) = [];
        tf = ismember( {subsubsubdir.name}, {'.', '..'});
        subsubsubdir(tf) = [];
        numberOfsubsubFolders = length(subsubsubdir);
      
        for L= 1: numberOfsubsubFolders
            L
            thissubsubsubdir = subsubsubdir(L).name;
            subsubsubdirpath = [subsubdirpath '\' thissubsubsubdir];
            mkdir(subnewfolderpath , thissubsubsubdir)
            subsubnewfolderpath = [subnewfolderpath '\' thissubsubsubdir]
            filenames = dir(subsubsubdirpath)
            %filenames(~[filenames.isdir]) = [];
            tf = ismember( {filenames.name}, {'.', '..'});
            filenames(tf) = [];
            filenames1 = dir(strcat(filenames(1).folder, '\*.dcm'))
            
            imagelength = length(filenames);
            for  y = 1: imagelength
                y
                filenamepath = [filenames1(y).folder '\' filenames1(y).name];
                x= dicomread(filenamepath);
                k = strsplit(filenames1(y).name, '.dcm');
                name = k(1);
                name = char(name);
                b = {name,'.png'};
                b = strjoin(b);
                savepath = fullfile(subsubnewfolderpath ,b );
                imwrite(x , savepath);
                    
                
                
                 
            end
            
        end
     end
    
    
    
end
