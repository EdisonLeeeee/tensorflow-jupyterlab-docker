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
                        zip \
                        build-essential \
                        curl \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
## END - change apt sources and install packages


## START - Python packages
COPY requirements.txt /tmp

RUN pip3 install pip -U  -i https://pypi.tuna.tsinghua.edu.cn/simple \
    && pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple \
    && pip install -r /tmp/requirements.txt --default-timeout=100 \
    # Other packages that depend on the packages in requirements.txt
    && pip install torch-scatter torch-sparse torch-cluster torch-geometric torch-spline-conv SciencePlots
## END - Python packages

# COPY zsh-in-docker.sh /tmp
# RUN sh -c "$(cat /tmp/zsh-in-docker.sh)" -- \
#     -p "git" \
#     -p https://github.com/zsh-users/zsh-autosuggestions \
#     -p https://github.com/zsh-users/zsh-completions \
#     -p https://github.com/zsh-users/zsh-history-substring-search \
#     -p https://github.com/zsh-users/zsh-syntax-highlighting

# install zsh
RUN apt-get update && apt-get install -y \
    zsh \
    git-core && rm -rf /var/lib/apt/lists/*
    
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
    && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \
    && chsh -s /bin/zsh
    
# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888

ENV type lab
CMD ["bash", "-c", "jupyter ${type} --ip 0.0.0.0 --port=8888 --notebook-dir=/home/${NB_USER} --no-browser --allow-root"]