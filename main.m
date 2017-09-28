clear;

%% Configuração Inicial

%trainFolder = './Treinamento/';             % Pasta de treinamento               
%files = dir('./Treinamento/*.png');         % Nome dos arquivos
path = './Treinamento/30_12.png';
im = imread(path);
im = imresize(im,[64 128]);                % Redimencionamento da imagem
im = rgb2gray(im);

HogCompute(im,[8 8],9);