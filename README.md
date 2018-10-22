# Traffic Sign Recognition

thesis: [Recognition of Traffic Sign with Digital Image Processing and Machine Learning](https://wiki.sj.ifsc.edu.br/wiki/images/5/58/Monografia_Mathias_Silva_da_Rosa.pdf "Recognition of Traffic Sign with Digital Image Processing and Machine Learning")

This job has as objective to introduce a study of automatic traffic sign recognition system divided into five steps: aquisition, preprocessing with the use of HSV model and techniques such as limiarization, morphology and edge detection; segmentation with the use of generalized Hough transform; description with the use of Histograms of Oriented Gradients (HOG) and finally, classification with the use of Support Vectors Machine (SVM). The proposed algorithm is made with MATLAB platform. 

#### Traning

The images for traning is in the below path

```
./Dataset/Training/*
```

The images are divided 11 classes of traffic sign:

* 30 - 30 km/h speed limit
* 50 - 50 km/h speed limit
* 60 - 60 km/h speed limit
* 70 - 70 km/h speed limit
* 80 - 80 km/h speed limit
* 100 - 100 km/h speed limit
* 120 - 120 km/h speed limit
* B - Do Not Enter
* C - No Passing (for any vehicle type)
* D - No Passing (by vehicles over 3,5 t)
* STOP

All images have been taken from [GTSDB](http://benchmark.ini.rub.de/) and they are only related to signs with circle format and red color. Each folder contains a spefic quantity of positive and negative examples. To run the training process execute de **Training.m** file in the root folder of the project.The traning process will generate the SVM model to each class of traffic sign and will put them in the below path. 

```
./Results/TrainedSVMs/*
```

#### Test

The test process is described in the image below.

![test_process](imgs/test_precss.png)

The test process will use the scripts contained in the folders called HOG, Preprocessing, Segmentation and Templates.