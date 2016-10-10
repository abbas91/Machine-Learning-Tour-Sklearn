# Machine-Learning-Quick-Tour
A collections of lab design for project training.

## Environment Setup
1. Clone the project
2. docker build -t="ml_training" .
3. docker run -d -p 8888:8888 -v /home/training/Machine-Learning-Tour-Sklearn:/home/training/notebooks ml_training
4. Go to localhost:8888, and you should see the notebook running

> For windows/MACOS user, be sure to share the folder in the docker setting first

