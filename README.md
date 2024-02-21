# Pretrained dlCHOMP Planners for Manipulator Motion Planning
This repository provides pretrained dlCHOMP robotic manipulator trajectory planners for MATLAB®. These trajectory planners can output optimized start to goal trajectories in a given spherical obstacle environment. [![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=matlab-deep-learning/pretrained-dlCHOMP)

![dlCHOMP High Level Visualization](/resources/images/dlCHOMP_High-Level_Vizualization.png)

**Creator**: MathWorks Development

**Includes un-trained model**: ❌  

**Includes transfer learning script**: ❌  
(![See this page for examples](https://www.mathworks.com/help/releases/R2024a/robotics/ref/dlchomp.html#mw_87c86e03-23d5-48f9-818f-356a363287ab)) 

**Supported Robots**: [See this page](https://www.mathworks.com/help/releases/R2024a/robotics/ref/dlchomp.html#mw_93957c22-f6cc-4e8c-ac45-1ae16cfcb2ef)

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

### Download the Pretrained Planner and Network
Use the code below to download the pretrained `dlCHOMP` planner and pretrained `dlnetwork` network for a supported robot. For a list of pretrained planner URLs, refer to the supported robots link specified under the [repository overview section above](#pretrained-dlchomp-planners-for-manipulator-motion-planning).

```matlab
robotName = 'kukaIiwa7';
data = helper.downloadPretrainedDLCHOMPFromURL(robotName);
```

### Summarize Pretrained Network
Use the code below to extract the pretrained network, summarize and analyze it.

```matlab
pretrainedNetwork = data.trainedNetwork;
summary(pretrainedNetwork);
analyzeNetwork(pretrainedNetwork);
```

If you only wished to obtain the network and not the planner, you can skip the next few sections, otherwise, continue.

### Obtain Pretrained Planner
Use the code below to extract the pretrained planner.

```matlab
pretrainedDLCHOMP = data.trainedDLCHOMP;
```

### Predict Trajectory Using Pretrained Planner
Use the code below to predict a start to goal trajectory on an example obstacle environment using the pretrained planner.

```matlab
% Make obstacle environment known to pretrained dlCHOMP.
pretrainedDLCHOMP.SphericalObstacles = data.unseenObstacles;

% Predict start to goal trajectory using pretrained planner.
[optimWpts,optimTpts,solinfo] = optimize(pretrainedDLCHOMP,data.unseenStart,data.unseenGoal);

% Visualize results.
show(pretrainedDLCHOMP,optimWpts);
```
![dlCHOMP Output Prediction](/resources/images/dlCHOMP_Output_Prediction.png)

### Train Custom dlCHOMP From Scratch
To generate data and train a custom dlCHOMP planner from scratch, follow the [Getting Started with DLCHOMP Optimizer for Manipulator Motion Planning](https://link-to-example) example.

### Train Custom dlCHOMP Using Transfer Learning
Transfer learning enables you to adapt a pretrained dlCHOMP planner to your dataset. Create a custom dlCHOMP planner and train it for transfer learning to:
- A different number of waypoints in trajectory by following the [Using Pretrained DLCHOMP Optimizer to Predict Higher Number of Waypoints](https://link-to-example) example.
- A different spherical obstacle environment and/or a different set of CHOMP optimization options by following the [Using Pretrained DLCHOMP Optimizer in Unseen Obstacle Environment](https://link-to-example) example.

## dlCHOMP Details

Optimization based motion planning tasks can be sped up using deep learning[1]. **dlCHOMP** is one such feature that utilizes a neural network initial guesser to provide an educated initial guess for a robot trajectory, which is then optimized using the **Covariant Hamiltonian Optimization for Motion Planning (CHOMP)**[2] algorithm.

![dlCHOMP Overview](/resources/images/dlCHOMP_Overview.png)

- **Env**: This is the spherical obstacle environment in which robot motion planning is to be performed. This is provided as a 4xN numeric input matrix to dlCHOMP. This input is the fed to the **CHOMP** and **BPS Encoder** modules.
- **BPS Encoder**: This is an obstacle environment encoder that uses a technique known as basis point set encoding. The basis point set is a set of fixed points that are used to convert arbitrary size obstacle environment into a fixed size encoding vector. This encoding vector is then fed as input to the **Initializer** along with the desired start and goal configurations of the robot.
- **Initializer**: This is a feed-forward neural network that guesses an initial trajectory for a robot by taking a start configuration, an end configuration and an obstacle environment encoding vector as inputs.
- **CHOMP**: This is an optimizer that uses the Covariant Hamiltonian Optimization for Motion Planning[2] algorithm. It takes the initial trajectory guess output of the initializer and the spherical obstacle environment **Env** as its inputs to then output an optimized start to goal trajectory.


### Neural Network Initializer Details

![dlCHOMP Network Architecture](/resources/images/dlCHOMP_Network_Architecture.png)

The architecture of dlCHOMP planner’s neural network **Initializer** module is shown above[2]. It takes a given motion task (world **WB**, start configuration **q1** and end configuration **qNt**) to output an initial guess **Q**. Blocks of tapered Fully Connected Layers (gray) are combined like the DenseNet architecture[3] via skip-connections and concatenations.

## Metrics and Evaluation

### Size and Accuracy Metrics

The test dataset considered for each model consisted of 500 data samples and was the same as the validation dataset created while generating the training data for the model as shown in the **Training Data Generation section** above.

| dlCHOMP Model           | Size (MB) | % of samples with dlCHOMP Itns < CHOMP | Mean % of Itns Saved  | % of samples with dlCHOMP Inference Time < CHOMP | Mean % of Time Saved | Feasibility
|-----------------|:----------------------:|:----------------------------:|:---------:|:---------:|:---------:|:---------:|
| kukaIiwa7 |       25        |               84.60           |  79.98     | 74.10 | 72.23 | 76.00 |


### CPU Time Metrics

The average neural guess times and average inference times were computed over the test dataset consisting of 500 data samples.

| dlCHOMP Model without codegen                           | Avg. Neural Guess Time (secs) | Avg. Inference Time (secs)|
|---------------------------------|:---------------------:|:---------------------:|
| kukaIiwa7 |         0.0609     | 0.2586|



## References
[1] J. Tenhumberg, D. Burschka and B. BÃ¤uml, "Speeding Up Optimization-based Motion Planning through Deep Learning," 2022 IEEE/RSJ International Conference on Intelligent Robots and Systems (IROS), Kyoto, Japan, 2022, pp. 7182-7189, doi: 10.1109/IROS47612.2022.9981717.

[2] N. Ratliff, M. Zucker, J. A. Bagnell and S. Srinivasa, "CHOMP: Gradient optimization techniques for efficient motion planning," 2009 IEEE International Conference on Robotics and Automation, 2009, pp. 489-494, doi: 10.1109/ROBOT.2009.5152817.

[3] S. J´egou et al., “The one hundred layers tiramisu: Fully convolutional densenets for semantic segmentation,” CoRR, vol. abs/1611.09326, 2016

Copyright 2024 The MathWorks, Inc.
