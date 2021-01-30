clear, clc;

I1 = imread('img1.jpg');
I2 = imread('img2.jpg');
I3 = imread('img3.jpg');
I4 = imread('img4.jpg');
I5 = imread('img5.jpg');
I6 = imread('img6.jpg');
I7 = imread('img7.jpg');
I8 = imread('img8.jpg');

myFunction(I1);
myFunction(I2);
myFunction(I3);
myFunction(I4);
myFunction(I5);
myFunction(I6);
myFunction(I7);
myFunction(I8);


function myFunction(I)
%%components of rgb image
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);

%%getting the orange part of image
Ic = imcrop(I);

miniR = sort(min(Ic(:,:,1)),'ascend');
maxiR = sort(max(Ic(:,:,1)),'ascend');
miniG = sort(min(Ic(:,:,2)),'ascend');
maxiG = sort(max(Ic(:,:,2)),'ascend');
miniB = sort(min(Ic(:,:,3)),'ascend');
maxiB = sort(max(Ic(:,:,3)),'ascend');


%%corped=uint8(zeros(size(Ic,1),size(Ic,2)));
%%count = 1;
%%pixnumber = size(Ic,1)*size(Ic,2);
%%arr(1,pixnumber); 

%%I need gray image because rgb doesn't work when getting row and column
Ig = rgb2gray(I);
g = uint8(zeros(size(Ig,1),size(Ig,2),3));


for i = 1:1:size(Ig,1)
    for j = 1:1:size(Ig,2)
        if (I(i,j,1) >= miniR(1) && I(i,j,1) <= maxiR(1)) && (I(i,j,2) >= miniG(2) && I(i,j,2) <= maxiG(2)) && (I(i,j,3) >= miniB(3) && I(i,j,3) <= maxiB(3))
            g(i,j,:) = [255,255,255];
        else
            g(i,j,:) = [0,0,0];
        end
    end
end

%figure; imshow(g,[]);


% R2 = g(:,:,1);
% G2 = g(:,:,2);
% B2= g(:,:,3);
%turning it into gray image will give me the same results in terms of their
%pixel value. for the R G and B all three of them will be 255 at the points
%which is white
newg = rgb2gray(g);
figure; imshow(newg,[]);


noNoise=uint8(zeros(size(newg,1),size(newg,2)));
arra=zeros(1,9);
row=size(newg,1);
col=size(newg,2);
padded=uint8(zeros(row+2,col+2)); 
padded(2:row+1,2:col+1)= newg;


for i=2:1:row+1
    for j=2:1:col+1
        arra(1,1)= padded(i-1,j-1);
        arra(1,2)= padded(i,j-1);
        arra(1,3)= padded(i+1,j-1);
        arra(1,4)= padded(i-1,j);
        arra(1,5)= padded(i,j);
        arra(1,6)= padded(i+1,j);
        arra(1,7)= padded(i-1,j+1);
        arra(1,8)= padded(i,j+1);
        arra(1,9)= padded(i+1,j+1);
        %%now they are all in my array
        newarra=sort(arra,'ascend'); %%they are sorted now
        noNoise(i-1,j-1)= newarra(5); %found the median and put it to my new picture
        
        
    end
end

figure; imshow(noNoise,[]);
%filling the unnecessary holes to smooth the image
I123=imfill(noNoise,'holes');
imshow(I123,[]); 

%%trying not to get areas that are too small 
se = strel('disk',15);
newI = imopen(I123,se);
imshow(newI,[]);
final = edge(newI,'sobel');

[labeledImage, numberOfOranges] = bwlabel(final);
figure; imshow(final,[]);

%text(10,10,strcat('\color{green}Objects Found:',numberOfOranges));

%shows the number of oranges at the command window
disp('Objects found');
disp(numberOfOranges);

end



