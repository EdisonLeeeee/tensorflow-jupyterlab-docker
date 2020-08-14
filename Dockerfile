FROM tensorflow/tensorflow:2.1.0-gpu-py3

MAINTAINER  Jintang Li <lijt55@mail2.sysu.edu.cn>
ENV NB_USER jtli
ENV HOME /home/$NB_USER

## SETUP - change apt sources and install packages

# then install packages    
RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y  git \
                        git-core\
                        nodejs \
                        zsh \
                        openssh-server \
                        vim \
                        tree \
                        libmetis-dev \
                        libopenblas-dev \
                        libssl-dev \          
                        build-essential \
                        wget \
                        cmake \
                        curl \
                        iputils-ping \
                        apt-utils \
                        zip \
                        unzip \
                        unrar \
                        ca-certificates \
                        wget \
                        git \
                        vim \
                        zsh-syntax-highlighting \
                        net-tools \
    && apt-get install -y npm \
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
    && pip install SciencePlots
    
# PyTorch geometric deel learning packages depend on PyTorch
RUN pip install torch-scatter torch-sparse torch-cluster torch-geometric torch-spline-conv
## END - Python packages

# COPY zsh-in-docker.sh /tmp
# RUN sh -c "$(cat /tmp/zsh-in-docker.sh)" -- \
#     -p "git" \
#     -p https://github.com/zsh-users/zsh-autosuggestions \
#     -p https://github.com/zsh-users/zsh-completions \
#     -p https://github.com/zsh-users/zsh-history-substring-search \
#     -p https://github.com/zsh-users/zsh-syntax-highlighting

# install zsh and plugins
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
    && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \
    && chsh -s /bin/zsh \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions    
    
# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888

ENV type lab
CMD ["zsh", "-c", "jupyter ${type} --ip 0.0.0.0 --port=8888 --notebook-dir=/home/${NB_USER} --no-browser --allow-root --NotebookApp.allow_remote_access=True"]