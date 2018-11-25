function [xs, ys] = SnakeMovement(image, xs, ys, sigma, alpha, beta, ds, dt, wline, wedge, wterm, N);
%Esta fun��o implementa o algoritmo SNAKE para contornos ativos descritos
%no artigo de Porril e Ivins (https://mat-web.upc.edu/people/toni.susin/files/SnakesAivru86c.pdf)
%Recebe como parametros entrada uma imagem do tipo double, as coordenadas no contorno
%inicial xs e ys, o desvio padr�o utilizado para o filtro gaussiano contido
%no algoritmo, as constantes alpha e beta que definem a elasticidade e
%rigidez do movimento interno do contorno ativo, os steps ds e dt (espa�o e tempo), 
%que regem o movimento do contorno nestas dimens�es , as constantes de
%propor��o wline, wedge, wterm, que determinam a atra��o do contorno a
%linhas, bordas e termina��es, respectivamente, e o n�mero de itera��es N
%Devolve na sa�da as coordenadas xs ys do contorno ap�s N itera��es


%TRANSFORMA EM GRAYSCALE CASO N�O SEJA
I = image;
if(size(image,3) > 1)
   I = rgb2gray(image); 
end;

%Calculo das energias de imagem conforme descrito por Kass

%ENERGIA DAS LINHAS - Region functional
%"The simplest potential energy is the unprocessed image intensity so that P(x) = I(x):"
Eline = I;

%ENERGIA DAS BORDAS - Edge functional
%"A very simple energy functional. If we set Eedge = |Vl(x,y)|, then the snake is attracted to contours
%with large image gradients."
[Ix Iy] = gradient(I);
Eedge = -(Ix.^2 + Iy.^2);

%ENERGIA DAS TERMINA��ES - Termination functional
%"The ends of line segments, and therefore corners, can be found using an energy term based on
%the curvature of lines in a slightly smoothed image C(x, y) = G?(x, y) * I(x, y)". 
h = fspecial('gaussian', ceil(3*sigma),sigma);
Ig = imfilter(I,h,'same'); 
mx = [1 0 -1];
my = [1; 0; -1];
mxx = [1 -2 1];
myy = [1;-2;1];
mxy = 1/4*[-1 0 1; 0 0 0; 1 0 -1];
Cx = conv2(Ig,mx,'same');
Cy = conv2(Ig,my,'same');
Cxx = conv2(Ig,mxx,'same');
Cyy = conv2(Ig,myy,'same');
Cxy = conv2(Ig,mxy,'same');
Eterm = (Cyy.*Cx.^2 -2*Cxy.*Cx.*Cy + Cxx.*Cy.^2)./((1+Cx.^2 + Cy.^2).^(3/2));


P = (wline*Eline + wedge*Eedge + wterm*Eterm); %Energia potencial da imagem.
[fx, fy] = gradient(P); %For�as na imagem, derivada espacial da energia potencial

figure;
imshow(P,[]);
title('Energia da imagem')


%MATRIZ DAS FOR�AS INTERNAS DA COBRA

nPoints = length(xs);
ds2 = ds*ds;
ds4 = ds2*ds2;

%GERADO DE ACORDO COM PORRILL E IVINS, QUE DIFERE UM POUCO DA FORMA DE KASS
%IMPLEMENTA��O DO PSEUDO C�DIGO DO ARTIGO DE PORRIL E IVINS
%ALPHA - ELASTICIDADE
%BETA - RIGIDEZ
%ds - SPACE STEP -> FAZ A FUN��O DO GAMMA DO ARTIGO DO KASS
%dt - TIME STEP -> FAZ A FUN��O DO KAPPA DO ARTIGO DO KASS
a=alpha*dt/ds2; 
b=beta*dt/ds4;
p=b;
q=-a-4*b; 
r=1+2*a+6*b;

%GERA MATRIZ PENTADIAGONAL
M=p*circshift(eye(nPoints),2);
M=M+q*circshift(eye(nPoints),1);
M=M+r*circshift(eye(nPoints),0);
M=M+q*circshift(eye(nPoints),-1);
M=M+p*circshift(eye(nPoints),-2);

%PEGA A INVERSA
[L U] = lu(M);
Minv = inv(U) * inv(L); % Fatora��o LU para diminuir tempo computacional
 

%MOVE A COBRA, IMPLEMENTADO DO PSEUDOC�DIGO MOSTRADO POR PORRILL E IVINS
figure;
for i=1:N;
    
    xs = Minv *(xs + dt*interp2(fx,xs,ys,'*linear'));
    ys = Minv *(ys + dt*interp2(fy,xs,ys,'*linear'));
    
    %PLOTA COBRA, MUDANDO DE VERDE PRA VERMELHO DE ACORDO DE QU�O PROXIMO
    %EST� DA ULTIMA ITERA��O
    imshow(image,[]); 
    hold on;
    c = i/N;
    plot([xs; xs(1)], [ys; ys(1)], '-','Color',[c 1-c 0],'linewidth',2.0);
    hold off;
    pause(0.001)   
end;

display('Fim das itera��es')