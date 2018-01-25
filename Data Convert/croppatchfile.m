mainFolder = 'C:\Users\cis\Documents\Breast cancer\mass_test';
savefolder = 'C:\Users\cis\Documents\Breast cancer\mass_test_crop'
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
            filenames1 = dir(strcat(subsubsubdirpath, '\*.xml'))
            
            imagelength = length(filenames);
            for  y = 1: imagelength
                y
                
                filenamepath = [filenames(y).folder '\' filenames(y).name];
                
                img = imread(filenamepath);
                %imshow(img)
                lenght = size(img, 1)
                
                if lenght > 1150
                    
                    [level] = graythresh(img);
                    BW = im2bw(img,level);
                    [BWm] = imerode(BW,strel('disk',10)); 
                    %figure, imshow(BWm)
                    [BWmm] = imdilate(BWm,strel('disk',15)); 
                    %figure, imshow(BWmm)
                    B = img.*uint8(BWmm); % BWmm is the mask
                    projX = any( BWmm, 1 ); % projection of mask along x direction
                    projY = any( BWmm, 2 ); % projection of mask along y direction
                    fx = find( projX, 1, 'first' ); % first column with non-zero val in mask
                    tx = find( projX, 1, 'last' );  % last column with non-zero val in mask
                    fy = find( projY, 1, 'first' ); % first row with non-zero val in mask
                    ty = find( projY, 1, 'last' );  % last row with non-zero val in mask
                    cropRect = [fx, fy, tx-fx+1, ty-fy+1];
                    cImg = imcrop( img, cropRect );
                    savepath = fullfile(subsubnewfolderpath ,filenames(y).name) 
                    %RGB2 = imresize(cImg, [299 299]);
                    %imshow(RGB2)
                    imwrite(cImg , savepath, 'png')
                    %copyfile(filenamepath, subsubnewfolderpath , 'f')
                else
                    copyfile(filenamepath, subsubnewfolderpath , 'f')
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
