clc
clear all;
close all;

I = imread('img1.tif');
I = im2double(I); 
figure, imshow(I); 
[x,y] = getpts;
 
sigma = 1;
alpha = 2;
beta = 1.5;
ds = 1.5;
dt = .05;
wline = 20;
wedge = 1000;
wterm = 500;
N = 800; 
[xs, ys] = SnakeMovement(I,x,y,sigma,alpha,beta,ds,dt,wline,wedge,wterm,N);
BW = roipoly(I,xs,ys);
figure;
imshow(I.*BW);
