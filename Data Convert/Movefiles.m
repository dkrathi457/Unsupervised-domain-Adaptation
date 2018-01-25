mainFolder = 'C:\Users\cis\Documents\Lung cancer\DOI';
savefolder = 'C:\Users\cis\Documents\Lung cancer\xml'
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
        %mkdir(newfolderpath , thissubsubdir)
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
            %mkdir(subnewfolderpath , thissubsubsubdir)
            subsubnewfolderpath = [subnewfolderpath '\' thissubsubsubdir]
            filenames = dir(subsubsubdirpath)
            %filenames(~[filenames.isdir]) = [];
            tf = ismember( {filenames.name}, {'.', '..'});
            filenames(tf) = [];
            filenames1 = dir(strcat(subsubsubdirpath, '\*.xml'))
            
            imagelength = length(filenames1);
            for  y = 1: imagelength
                y
                
                filenamepath = [filenames1(y).folder '\' filenames1(y).name];
                lenght = size(dir(filenames1(y).folder), 1)
                
                if lenght > 10
                    
                    copyfile(filenamepath, newfolderpath , 'f')
                end
                
                %x= dicomread(filenamepath);
                %x1 = uint8(255 * mat2gray(x));
                %x1 = im2double(x);
                %k = strsplit(filenames1(y).name, '.dcm');
                %name = k(1);
                %name = char(name);
                %b = {name,'.png'};
                %b = strjoin(b);
                %savepath = fullfile(subsubnewfolderpath ,b );
                %imwrite(x1 , savepath, 'png');
                             
                
                    
                
                
                 
            end
            
        end
     end
    
    
    
end
