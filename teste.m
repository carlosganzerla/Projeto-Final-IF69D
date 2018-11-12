clc
clear all;
close all;

I = imread('img2.tif');
I = im2double(I); 
figure, imshow(I); 
[x,y] = getpts;
 
sigma = 2;
alpha = 4;
beta = 1.2;
ds = 1.5;
dt = .02;
wline = 150;
wedge = 9000;
wterm = 600;
N = 500; 
[xs, ys] = SnakeMovement(I,x,y,sigma,alpha,beta,ds,dt,wline,wedge,wterm,N);

 