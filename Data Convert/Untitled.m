I=im2uint16(x);
figure,imshow(I)
PSF = fspecial('gaussian',7,10);
V = .0001;
BlurredNoisy = imnoise(imfilter(I,PSF),'gaussian',0,V);
figure,imshow(BlurredNoisy)
WT = zeros(size(I));
WT(5:end-4,5:end-4) = 1;
J1 = deconvlucy(BlurredNoisy,PSF);
figure,imshow(J1)
for k=1:3
   imwrite(J1(:,:,k),'C:\Users\cis\Documents\Lung cancer\MyOutput.tif','tif','WriteMode','append');
end