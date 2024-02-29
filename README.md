# Pretrained DLCHOMP Networks for Manipulator Motion Planning
This repository provides pretrained networks for Deep-Learning-Based Covariant Hamiltonian Optimization for Motion Planning (DLCHOMP) of robotic manipulators for MATLAB®. These pretrained networks can output intermediate trajectory guesses for desired start to goal configurations in a given spherical obstacle environment. [![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=matlab-deep-learning/pretrained-dlCHOMP)

![dlCHOMP High Level Visualization](/resources/images/dlCHOMP_High-Level_Vizualization.png)

**Creator**: MathWorks Development

**Includes un-trained model**: ❌  

**Includes transfer learning script**: ✅  
([See this page](https://www.mathworks.com/help/releases/R2024a/robotics/ref/dlchomp.html#mw_87c86e03-23d5-48f9-818f-356a363287ab))

**Supported Robots**: ✅   
([See this page](https://www.mathworks.com/help/releases/R2024a/robotics/ref/dlchomp.html#mw_93957c22-f6cc-4e8c-ac45-1ae16cfcb2ef))

## Requirements
- MATLAB® R2024a or later
- Robotics System Toolbox™
- Deep Learning Toolbox™

## Getting Started
Download or clone this repository to your machine and open it in MATLAB®.

### Setup
Add path to the source directory.

```matlab
addpath("src");
```

### Download the Pretrained Network
Use the code below to download the pretrained network for a supported robot. For a list of supported robots, refer to the table under the [metrics and evaluation section](#metrics-and-evaluation) below. Let's see the workflow for **kukaIiwa7** since it is one such supported robot.

```matlab
robotName = "kukaIiwa7";
data = helper.downloadPretrainedDLCHOMPForRobot(robotName);
```

To download the pretrained network for another supported robot, simply replace `robotName` above with a supported robot name.

### Summarize Pretrained Network
Use the code below to extract the pretrained network, then summarize and analyze it.

```matlab
pretrainedNetwork = data.trainedNetwork;
summary(pretrainedNetwork);
analyzeNetwork(pretrainedNetwork);
```

If you only wished to obtain the pretrained network and not the pretrained planner, you can skip the next few sections, otherwise, continue.

### Obtain Pretrained DLCHOMP Planner
Use the code below to extract the pretrained planner.

```matlab
pretrainedDLCHOMP = data.trainedDLCHOMP;
```

### Predict Trajectory Using Pretrained DLCHOMP Planner
Use the code below to predict a start to goal trajectory on an example obstacle environment using the pretrained planner.

```matlab
% Make obstacle environment known to pretrained dlCHOMP planner.
pretrainedDLCHOMP.SphericalObstacles = data.unseenObstacles;

% Predict start to goal trajectory using planner.
[optimWpts,optimTpts,solinfo] = optimize(pretrainedDLCHOMP,data.unseenStart,data.unseenGoal);

% Visualize results.
show(pretrainedDLCHOMP,optimWpts);
```
![dlCHOMP Output Prediction](/resources/images/dlCHOMP_Output_Prediction.png)

### Train Custom DLCHOMP Planner From Scratch
To generate data and train a custom DLCHOMP planner from scratch, follow the [Getting Started with DLCHOMP Optimizer for Manipulator Motion Planning](https://link-to-example) example.

### Train Custom DLCHOMP Planner Using Transfer Learning
Transfer learning enables you to adapt a pretrained DLCHOMP planner to your dataset. Follow these examples to create a custom DLCHOMP planner and train it for transfer learning to:
- A different number of waypoints in trajectory by following the [Using Pretrained DLCHOMP Optimizer to Predict Higher Number of Waypoints](https://www.mathworks.com/help/releases/R2024a/robotics/ug/retrain-dlchomp-optimizer-for-different-trajectory.html) example.
- A different spherical obstacle environment and/or a different set of CHOMP optimization options by following the [Using Pretrained DLCHOMP Optimizer in Unseen Obstacle Environment](https://www.mathworks.com/help/releases/R2024a/robotics/ug/retrain-dlchomp-optimizer-for-new-environment.html) example.

## DLCHOMP Details

Optimization based motion planning tasks can be sped up using deep learning[[1]](#references). [dlCHOMP](https://www.mathworks.com/help/releases/R2024a/robotics/ref/dlchomp.html) is one such MATLAB® feature that utilizes a neural network initial guesser to provide an educated initial guess for a robot's intermediate start to goal trajectory, which is then optimized using the **Covariant Hamiltonian Optimization for Motion Planning (CHOMP)**[[2]](#references) algorithm.

![dlCHOMP Overview](/resources/images/dlCHOMP_Overview.png)

- **Env**: This is the spherical obstacle environment in which robot motion planning is to be performed. This is provided as a 4xN numeric input matrix to `dlCHOMP`. This input is the fed to the **CHOMP** and **BPS Encoder** modules.
- **BPS Encoder**: This is an obstacle environment encoder that uses a technique known as basis point set encoding. The basis point set is a set of fixed points that are used to convert arbitrary size obstacle environment into a fixed size encoding vector. This encoding vector is then fed as input to the **Initializer** along with the desired start and goal configurations of the robot.
- **Initializer**: This is a feed-forward neural network that guesses an initial intermediate trajectory for a robot by taking a start configuration, an end configuration and an obstacle environment encoding vector as inputs. An intermediate trajectory is a trajectory that does not include the start and goal configurations. More details on the architecture of this neural network can be seen in the [Neural Network Details section](#neural-network-details) below.
- **CHOMP**: This is an optimizer that uses the Covariant Hamiltonian Optimization for Motion Planning[[2]](#references) algorithm. It takes the initial intermediate trajectory guess output of the **Initializer** and the spherical obstacle environment **Env** as its inputs to then output an optimized start to goal trajectory.


### Neural Network Details

![dlCHOMP Network Architecture](/resources/images/dlCHOMP_Network_Architecture.png)

The architecture of the DLCHOMP neural network is shown above[[2]](#references). It takes a given motion task (world **WB**, start configuration **q1** and end configuration **qNt**) to output an initial guess **Q**. Blocks of tapered Fully Connected Layers (gray) are combined like the DenseNet architecture[[3]](#references) via skip-connections and concatenations.

## Metrics and Evaluation

The test dataset considered for each pretrained network consisted of 1000 data samples, which were the same as the validation dataset created while generating the training data for training the network. These 1000 test samples were then flipped, for data augmentation, due to the symmetric nature of the motion planning problem, to create a total of 2000 test data samples. The results shown in the tables below are on such 2000 test data sample sets that were created for each robot.

### Size and Accuracy Metrics

<table>
 <tr>
    <th>Header</th>
    <th>Definition</th>
  </tr>
  <tr>
    <th>Size (MB)</th>
    <td>Memory footprint of the DLCHOMP planner object in megabytes.</td>
  </tr>
  <tr>
    <th>% of samples with DLCHOMP Itns < CHOMP</th>
    <td>Percentage of data samples where the <b>dlCHOMP</b> planner took lesser number of iterations than an equivalent <b>manipulatorCHOMP</b> planner with similar optimization options.</td>
  </tr>
  <tr>
    <th>Mean % of Itns Saved</th>
    <td>The mean percentage of iterations saved by the <b>dlCHOMP</b> planner for the data samples where the <b>dlCHOMP</b> planner took lesser iterations than the equivalent <b>manipulatorCHOMP</b> planner with similar optimization options.</td>
  </tr>
  <tr>
    <th>% of samples with dlCHOMP Inference Time < CHOMP</th>
    <td>Percentage of data samples where the <b>dlCHOMP</b> planner's optimization time was lesser than that of an equivalent <b>manipulatorCHOMP</b> planner with similar optimization options.</td>
  </tr>
  <tr>
    <th>Mean % of Inference Time Saved</th>
    <td>The mean percentage of inference time saved by the <b>dlCHOMP</b> planner for the data samples where the <b>dlCHOMP</b> planner took lesser iterations than that of an equivalent <b>manipulatorCHOMP</b> planner with similar optimization options. Inference time of a <b>dlCHOMP</b> planner is the sum of the network guess time and subsequant the optimization time. Inference time of a <b>manipulatorCHOMP</b> planner is the same as its optimization time since it does not have a neural network component.</td>
  </tr>
  <tr>
    <th>Feasibility</th>
    <td>The percentage of test data samples where the <b>dlCHOMP</b> planner gave a collision free optimized trajectory.</td>
</table>

The table above defines the headers present in the table below:

| DLCHOMP Planner | Size (MB) | % of samples with DLCHOMP Itns < CHOMP | Mean % of Itns Saved  | % of samples with dlCHOMP Inference Time < CHOMP | Mean % of Time Saved | Feasibility
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| fanucLRMate200ib | 25 | 87.20 | 80.42 | 79.10 | 72.30 | 78.65 |
| fanucM16ib | 25 | 75.30 | 82.17 | 67.40 | 76.09 | 73.95 |
| frankaEmikaPanda | 25 | 84.40 | 83.10 | 77.60 | 77.93 | 77.25 |
| kinovaJacoJ2S7S300 | 25 | 99.00 | 78.63 | 74.00 | 75.07 | 68.55 |
| kinovaGen3 | 25| 77.90 | 74.56 | 63.70 | 67.44 | 72.15 |
| kukaIiwa7 | 25 | 83.80 | 79.02 | 74.90 | 72.38 | 80.40 |
| meca500r3 | 25 | 85.00 | 79.24 | 74.90 | 71.41 | 65.15 |
| techmanTM5-700 | 25 | 78.40 | 74.49 | 67.40 | 66.38 | 71.20 |


### CPU Time Metrics

<table>
 <tr>
    <th>Header</th>
    <th>Definition</th>
  </tr>
  <tr>
    <th>Mean Network Guess Time (secs)</th>
    <td>The mean time taken by the <b>dlCHOMP</b> planner to obtain its neural network's intermediate guess trajectory in seconds.</td>
  </tr>
  <tr>
    <th>Mean Inference Time (secs)</th>
    <td>The mean of the total time taken by the <b>dlCHOMP</b> planner to obtain its neural network's intermediate guess trajectory and then optimize it using CHOMP, in seconds.</td>
  </tr>
</table>

The table above defines the headers present in the table below:

| dlCHOMP Model without codegen | Mean Network Guess Time (secs) | Mean Inference Time (secs)|
|:---:|:---:|:---:|
| fanucLRMate200ib | 0.0100 | 0.6899 |
| fanucM16ib | 0.0069 | 1.2242 |
| frankaEmikaPanda | 0.0075 | 1.6912 |
| kinovaJacoJ2S7S300 | 0.0098 | 4.4300 | 
| kinovaGen3 | 0.0072 | 3.0774 |
| kukaIiwa7 | 0.0060 | 1.5289 |
| meca500r3 | 0.0057 | 0.5911 |
| techmanTM5-700 | 0.0052 | 1.2719 |



## References
[1] J. Tenhumberg, D. Burschka and B. BÃ¤uml, "Speeding Up Optimization-based Motion Planning through Deep Learning," 2022 IEEE/RSJ International Conference on Intelligent Robots and Systems (IROS), Kyoto, Japan, 2022, pp. 7182-7189, doi: 10.1109/IROS47612.2022.9981717.

[2] N. Ratliff, M. Zucker, J. A. Bagnell and S. Srinivasa, "CHOMP: Gradient optimization techniques for efficient motion planning," 2009 IEEE International Conference on Robotics and Automation, 2009, pp. 489-494, doi: 10.1109/ROBOT.2009.5152817.

[3] S. J´egou et al., “The one hundred layers tiramisu: Fully convolutional densenets for semantic segmentation,” CoRR, vol. abs/1611.09326, 2016

Copyright 2024 The MathWorks, Inc.
