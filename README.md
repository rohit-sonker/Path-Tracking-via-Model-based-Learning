# Path-Tracking-via-Model-based-Learning

Project aims to track path on uneven terrain by a 4 wheel mobile robot using model based learning. Codebase is in MATLAB with simulation in VREP. 

VREP Control is to be established with Manta Robot. Terrain files are generated in matlab and imported in Vrep.

Controller : Contains files related to control setup. Uses MPC controller with a neural network, reward function. Other options are differential drive. Addition of terrain data is optional.

Training : Contains code related to data collection and training of neural network to act as model.
