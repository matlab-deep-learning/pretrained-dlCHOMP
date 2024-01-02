# Pretrained dlCHOMP for Manipulator Motion Planning
This repository provides pretrained dlCHOMP robotic manipulator trajectory prediction networks for MATLAB®. These trajectory predictors can predict start to goal trajectories in a given spherical obstacle environment. [![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=matlab-deep-learning/pretrained-dlCHOMP)

![dlCHOMP High Level Visualization](/resources/images/dlCHOMP_High-Level_Vizualization.png)

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

### Train Custom dlCHOMP From Scratch
To generate data and train a custom dlCHOMP network from scratch, follow the [Getting Started with DLCHOMP Optimizer for Manipulator Motion Planning](https://link-to-example) example.

### Train Custom dlCHOMP Using Transfer Learning
Transfer learning enables you to adapt a pretrained dlCHOMP network to your dataset. Create a custom dlCHOMP network and train it for transfer learning to:
- A different number of waypoints in trajectory by following the [Using Pretrained DLCHOMP Optimizer to Predict Higher Number of Waypoints](https://link-to-example) example.
- A different spherical obstacle environment and/or a different set of CHOMP optimization options by following the [Using Pretrained DLCHOMP Optimizer in Unseen Obstacle Environment](https://link-to-example) example.

## Deployment
Code generation enables you to generate code and deploy EfficientDet-D0 on multiple embedded platforms. Code generation for dlCHOMP will be suppored in a later release of MATLAB.

## dlCHOMP Details

EfficientDets are a family of object detection models. These are developed based on the advanced EfficientDet backbones, a new BiFPN module, and compound scaling technique. They follow the one-stage detectors paradigm.

![dlCHOMP Overview](/resources/images/dlCHOMP_Overview.png)

- **Env**: This is the spherical obstacle environment in which robot motion planning is to be performed. This is provided as a 4xN numeric input matrix to dlCHOMP. This input is the fed to the **CHOMP** and **BPS Encoder** modules.
- **BPS Encoder**: This is an obstacle environment encoder that uses a technique known as basis point set encoding. The basis point set is a set of fixed points that are used to convert arbitrary size obstacle environment into a fixed size encoding vector. This encoding vector is then fed as input to the **Initializer** along with the desired start and goal configurations of the robot.
- **Initializer**: This is a feed-forward neural network that guesses an initial trajectory for a robot by taking a start configuration, an end configuration and an obstacle environment encoding vector as inputs.
- **CHOMP**: This is an optimizer that uses the Covariant Hamiltonian Optimization for Motion Planning [1] algorithm. It takes the initial trajectory guess output of the initializer and the spherical obstacle environment **Env** as its inputs to then output an optimized start to goal trajectory.


### Network Network Initializer Details

![dlCHOMP Network Architecture](/resources/images/dlCHOMP_Network_Architecture.png)

The architecture of dlCHOMP’s **Initializer** module is shown above. It takes a given motion task (world **WB**, start configuration **q1** and end configuration **qNt**) to output an initial guess **Q**. Blocks of tapered Fully Connected Layers (gray) are combined like the DenseNet architecture [3] via skip-connections and concatenations.

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
