clc
clear all;
close all;

I = imread('mug1.png');
I = im2double(I); 
figure, imshow(I); 
[x,y] = getpts;
 
sigma = 5;
alpha = 4;
beta = 1.5;
ds = 2;
dt = .05;
wline = 1;
wedge = 5000;
wterm = 5000;
N = 500; 
[xs, ys] = SnakeMovement(I,x,y,sigma,alpha,beta,ds,dt,wline,wedge,wterm,N);

 