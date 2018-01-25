mainfolder = 'D:\Ond Drive this pc\OneDrive - UMASS Dartmouth\mias_png'
savefolder = 'D:\Ond Drive this pc\OneDrive - UMASS Dartmouth\mias_png\croppatches'

for i = 1: size(F_Name,1)
    
    filename = char(F_Name(i));
    radius = r(i);
    x_pos = x(i);
    y_pos = y(i);
    savepath = [savefolder '\' filename ' .png'];
    filepath = [mainfolder '\' filename ' .png'];
    I = imread(filepath);
    xLeft = x_pos - radius;
    width = xLeft + 2 * radius;
    yTop = y_pos - radius;
    height = yTop + 2 * radius;
    croppedImage = imcrop(I, [xLeft, width, yTop, height]);
    
    if exist(savepath, 'file')
        
        savepath1 = [savefolder '\' filename '-' '1 .png']
        imwrite(croppedImage,savepath1)
        
    else
         imwrite(croppedImage,savepath);
    end
    
    
    
end



I2 = imcrop(I,[75 68 130 112])