# Pretrained dlCHOMP for Manipulator Motion Planning
This repository provides pretrained dlCHOMP robotic manipulator trajectory prediction networks for MATLAB®. These trajectory predictors can predict start to goal trajectories in a given spherical obstacle environment. [![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=matlab-deep-learning/pretrained-dlCHOMP)

**Creator**: MathWorks Development

**Includes un-trained model**: ❌  

**Includes transfer learning script**: ❌ 

**Supported Robots**:

| Robot Name  | Supported |
| ------ | ------ |
| kinovaGen3 |✔️|
| universalUR5e |✔️|
| frankaEmikaPanda |✔️|
| kukaIiwa7 |✔️|
| abbYuMi |✔️|
| fanucM16ib |✔️|
| fanucLRMate200ib |✔️|
| techmanTM5-700 |✔️|
| kinovaJacoJ2S7S300 |✔️|
| meca500r3 |✔️|

## Requirements
- MATLAB® R2024a or later
- Robotics System Toolbox™
- Deep Learning Toolbox™

## Getting Started
Download or clone this repository to your machine and open it in MATLAB®.

### Setup
Add path to the source directory.

```matlab
addpath('src');
```

### Download the pretrained network
Use the code below to download the pretrained network for a supported robot.

```matlab
robotName = 'kukaIiwa7';
data = helper.downloadPretrainedDLCHOMPForRobot(robotName);
dlchomp = data.dlchomp;
```

### Predict Trajectory Using Pretrained dlCHOMP
Use the code below to predict a start to goal trajectory on an example obstacle environment using the pre-trained model.

```matlab
% Specify path to test sample.
pathToTestSample = fullfile('test',robotName,'sample.json');

% Read test environment's start, goal and obstacles.
[start,goal,obstacles,~] = helper.extractDataFromDLCHOMPSample(pathToTestSample);

% Make obstacles known to pretrained dlCHOMP.
dlchomp.SphericalObstacles = obstacles;

% Predict start to goal trajectory using pretrained model.
[optimWpts,optimTpts,solinfo] = optimize(dlchomp,start,goal);

% Visualize results.
show(dlchomp,optimWpts);
```
![Results](/resources/images/result.png)

### Train Custom dlCHOMP Using Transfer Learning
Transfer learning enables you to adapt a pretrained dlCHOMP network to your dataset. Create a custom dlCHOMP network and train it for transfer learning to:
- A different number of waypoints in trajectory by following the [Using Pretrained DLCHOMP Optimizer to Predict Higher Number of Waypoints](https://link-to-example) example.
- A different spherical obstacle environment and/or a different set of CHOMP optimization options by following the [Using Pretrained DLCHOMP Optimizer in Unseen Obstacle Environment](https://link-to-example) example.

## Deployment
Code generation enables you to generate code and deploy EfficientDet-D0 on multiple embedded platforms. Code generation for dlCHOMP will be suppored in a later release of MATLAB.

## Network Details

EfficientDets are a family of object detection models. These are developed based on the advanced EfficientDet backbones, a new BiFPN module, and compound scaling technique. They follow the one-stage detectors paradigm.

![EfficientDetArch](/images/network.png)

- **Backbone**: EfficientDets[3] are used as backbone networks for this class of object detectors. EfficientDets are a class of convolutional neural network architecture and scaling method that uniformly scales all dimensions of depth/width/resolution using a compound coefficient. Unlike conventional practice that arbitrary scales these factors, the EfficientDet scaling method uniformly scales network width, depth, and resolution with a set of fixed scaling coefficients. It has eight variants out of which, EfficientDet-B0 is used as the backbone for this model.
 
- **BiFPN Module**: A weighted bi-directional feature pyramidal network enhanced with fast normalization, which enables easy and fast multi-scale feature fusion. This module takes level 3-7 features (P3, P4, P5, P6, P7) from the backbone network and repeatedly applies top-down and bottom-up bidirectional feature fusion. These fused features are fed to a class prediction network and box prediction network to produce object class and bounding box predictions respectively. The class and box prediction network weights are shared across all levels of features.
This module is implemented using a combination of layers such as convolution, resize, element-wise multiplication, element-wise addition, element-wise division etc.
 
- **Scaling**: A compound scaling method that uniformly scales the resolution, depth, and width for all backbone, feature network, and box/class prediction networks at the same time. This method helps in optimizing both accuracy and efficiency for the model.

- **Class Prediction Net**: This network processes the fused features from the previous BiFPN modules and produces class prediction outputs. This network is implemented using a combination of layers such as convolution, sigmoid, element-wise multiplication etc.
 
- **Box Prediction Net**: This network processes the fused features from the previous BiFPN modules and produces bounding box prediction outputs. This network is implemented using a combination of layers such as convolution, sigmoid, element-wise multiplication etc.

## Metrics and Evaluation

### Size and Accuracy Metrics

| Model           | Input image resolution | Mean average precision (mAP) | Size (MB) |
|-----------------|:----------------------:|:----------------------------:|:---------:|
| EfficientDet-D0 |       512 x 512        |               33.7           |  15.9     |


mAP for models trained on the COCO dataset is computed as average over IoU of .5:.95.

### Deployment Metrics

| Model                           | Inference Speed (FPS) |
|---------------------------------|:---------------------:|
| EfficientDet-D0 without codegen |         4.8437        |
| EfficientDet-D0 + GPU Coder     |        27.3658        |

Performance (in FPS) is measured on a TITAN-RTX GPU using 512x512 image.


## References
[1] Tan, Mingxing, Ruoming Pang, and Quoc V. Le. "Efficientdet: Scalable and efficient object detection." In Proceedings of the IEEE/CVF conference on computer vision and pattern recognition, pp. 10781-10790. 2020.

[2] Lin, T., et al. "Microsoft COCO: Common objects in context. arXiv 2014." arXiv preprint arXiv:1405.0312 (2014).

[3] Tan, Mingxing, and Quoc Le. "Efficientnet: Rethinking model scaling for convolutional neural networks." International Conference on Machine Learning. PMLR, 2019.

Copyright 2021 The MathWorks, Inc.
