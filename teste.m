clc
clear all;
close all;

I = imread('img2.tif');
I = im2double(I); 
figure, imshow(I); 
[x,y] = getpts;
 
sigma = 1;
alpha = 3;
beta = 1.5;
ds = 1.2;
dt = .05;
wline = 5;
wedge = 3000;
wterm = 200;
N = 800; 
[xs, ys] = SnakeMovement(I,x,y,sigma,alpha,beta,ds,dt,wline,wedge,wterm,N);
BW = roipoly(I,xs,ys);
figure;
imshow(I.*BW);


 