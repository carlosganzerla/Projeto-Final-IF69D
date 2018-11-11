clc
clear all;
close all;

I = imread('img2.tif');
I = im2double(I); 
figure, imshow(I); 
[x,y] = getpts;
 
sigma = 2;
alpha = 3;
beta = 1.2;
ds = 1.5;
dt = .05;
wline = 5;
wedge = 1500;
wterm = 200;
N = 750; 
[xs, ys] = SnakeMovement(I,x,y,sigma,alpha,beta,ds,dt,wline,wedge,wterm,N);

 