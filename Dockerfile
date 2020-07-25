FROM tensorflow/tensorflow:2.1.0-gpu-py3

LABEL maintainer "Edisonleejt"
ENV NB_USER leejt
ENV HOME /home/$NB_USER

## SETUP - change apt sources and install packages
RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list \
    && apt-get update\
    && apt-get install -y  git \
                        openssh-server \
                        vim \
                        tree \
                        libmetis-dev \
                        wget \
                        cmake \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
## END - change apt sources and install packages


## START - Python packages
WORKDIR $HOME
ADD requirements.txt .

RUN pip3 install pip -U  -i https://pypi.tuna.tsinghua.edu.cn/simple \
    && pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple \
    && pip install -r requirements.txt --default-timeout=100 \
    && pip install torch-scatter torch-sparse torch-cluster torch-geometric torch-spline-conv
## END - Python packages

# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888


CMD ["bash", "-c", "jupyter lab --ip 0.0.0.0 --port=8888 --notebook-dir=/home/leejt --no-browser --allow-root"]