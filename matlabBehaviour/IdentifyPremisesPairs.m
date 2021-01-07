function IdentifyPremisesPairs(Horder,image1,image2)
if numel(image1)~=image2
    disp('Error, different sizes');
    return
end
Pair=cell(1,numel(image1));% allocate memory
%find out what is faces, objects and scenes
id_F=contains(image1,'face');id_O=contains(image1,'objc');id_S=contains(image1,'scen');
% find out the order of the elements within the hierarchy
A=Horder(1:6);B=Horder(7:12);C=Horder(13:18);

A1=[A(1:5);A(2:6)];A2=[A(2:6);A(1:5)];


