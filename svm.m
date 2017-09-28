clear;

%% Configuração Inicial - Treinamento

train_folder = './Treinamento/';             % Pasta de treinamento
pwd = strcat(train_folder,'*.png');                
files = dir('./Treinamento/*.png');          % Nome dos arquivos
files_count = size(files);                   % Quantidade de arquivos
feature_size = 4356;                         % Tamanho do descritor
signs = zeros(files_count(1),feature_size);  % Vetor de descritores
labels = cell(files_count(1),1);             % Vetor de labels

%% Obtenção dos descritores e respectivos labels

for i=1:files_count(1)
    pwd = strcat(train_folder,files(i).name);
    im = imread(pwd);                           % Leitura da imagem
    im = imresize(im,[100 100]);                % Redimencionamento da imagem
    im = rgb2gray(im);                          % Escala cinza                             %
    [featureVector,~] = extractHOGFeatures(im); % Extração do descritor
    signs(i,:) = featureVector;                 
    labels(i) = cellstr(files(i).name(1:2));
end

%% Treinamento da SVM

SVMModel = fitcsvm(signs,labels);

%% Configuração Inicial - Teste

test_folder = './Teste/';
pwd = strcat(test_folder,'*.png');
signs_test = dir(pwd);
files_count = size(signs_test);
result = cell(files_count(1),2);

%% Etapa de Testes

for j=1:files_count(1)
    pwd = strcat(test_folder,signs_test(j).name);
    im_test = imread(pwd);
    im_test = imresize(im_test,[100 100]);
    im_test = rgb2gray(im_test);
    [feature_test,~] = extractHOGFeatures(im_test);
    label = predict(SVMModel,feature_test);        % Predição 
    result(j,1) = cellstr(signs_test(j).name);
    result(j,2) = cellstr(label);
end

%% Resultados

result

