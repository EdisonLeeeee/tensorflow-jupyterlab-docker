# Tensorflow Jupyterlab Docker
This is my development environment using [TensorFlow](https://github.com/tensorflow/tensorflow) 2.1 GPU, Python3.6 and Jupyterlab.
I am mainly focus on Graph Neural Networks and Graph Adversarial Learning, so there are some Graph-relevant packages like [torch_geometirc](https://github.com/rusty1s/pytorch_geometric) installed.

On start, the container will start in jupyter lab,

# Environment
Ubuntu 18.04
Tensorflow 2.1.0 (with GPU)
CUDA 10.2
Python 3.6
Jupyterlab

# Usage
## Remove all dangling images
```
docker rmi -f $(docker images -q --filter "dangling=true")

```

## Build dockerfile
```
docker build -t <-Image Name-> .
```
or you can pull from [DockerHub](https://hub.docker.com/)
```
docker pull edisonleejt/tensorflow:2.1.0-gpu-py3-jupyterlab
```
## Run
Before that, you should install [nvidia-docker](https://github.com/NVIDIA/nvidia-docker) to use GPUs.
```
docker run -u $(id -u):$(id -g) -itd --rm --gpus all--name <-Container Name-> -p 8888:8888 -v /home/$USER:/home/$USER <-Image Name->
```
## Enter existing container
```
docker stop <-Container Name->
docker start <-Container Name->
docker exec -it  <-Container Name-> bash
```

## Start jupyter lab
```
jupyter lab --ip 0.0.0.0 --port=8888 --no-browser --allow-root
```
