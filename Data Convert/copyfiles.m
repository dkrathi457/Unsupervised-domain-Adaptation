

files = 'C:\Users\cis\Documents\Lung cancer\DOI\LIDC-IDRI-0511\1.3.6.1.4.1.14519.5.2.1.6279.6001.160580646297142988675326833498\1.3.6.1.4.1.14519.5.2.1.6279.6001.657775098760536289051744981056'
filesdir = dir(files)

k = 'C:\Users\cis\Documents\Lung cancer\DOI\LIDC-IDRI-0001\1.3.6.1.4.1.14519.5.2.1.6279.6001.175012972118199124641098335511\1.3.6.1.4.1.14519.5.2.1.6279.6001.141365756818074696859567662357'
split = strsplit(k , '\')

l= ['C:\Users\cis\Documents\Lung cancer\PNG1\' split(7) '\'  split(8) '\' split(9)]
l = strjoin(l)

lenght = size(dir(k),1)

if lenght > 10
    copyfile(k, dest , 'f')
end

dest = 'C:\Users\cis\Documents\Lung cancer\PNG1\ LIDC-IDRI-0001'
source = 'C:\Users\cis\Documents\Lung cancer\DOI\LIDC-IDRI-0001'