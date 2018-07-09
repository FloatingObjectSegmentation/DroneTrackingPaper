## Initial test

This folder contains the initial neural network experiment for drone detection.

### Preparation

- Use ```FloatingObjectSegmentation/SceneGen``` to create 1000 scenes containing drones
- Use ```FloatingObjectSegmentation/TrainingDataGenerator``` with the ```dronescan.py``` script to generate an arbitrarily large dataset of randomly sampled drones, then use the ```scenescan.py``` script with the outputs from ```SceneGen```.
- Use ```Voxelizer``` to transform the outputs from ```dronescan``` and ```scenescan``` to regular voxel occupancy grid.
- Use the ```kerastrain.py``` training script with the outputs of ```Voxelizer``` to train and measure the accuracy of a trained neural network. The architecture is copied from VoxNet (cite needed).