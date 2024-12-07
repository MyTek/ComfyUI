# https://github.com/krasamo/comfyui-docker/tree/main

FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=America/Los_Angeles

RUN apt-get update && apt-get install -y \
    git \
    make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev git git-lfs  \
    ffmpeg libsm6 libxext6 cmake libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/* \
    && git lfs install

WORKDIR /code

COPY ./requirements.txt /code/requirements.txt

# User
RUN useradd -m --groups users,sudo  -u 1000 user
USER user
ENV HOME=/home/user \
    PATH=/home/user/.local/bin:$PATH

# Pyenv
RUN curl https://pyenv.run | bash
ENV PATH=$HOME/.pyenv/shims:$HOME/.pyenv/bin:$PATH

ARG PYTHON_VERSION=3.10.12
# Python
RUN pyenv install $PYTHON_VERSION && \
    pyenv global $PYTHON_VERSION && \
    pyenv rehash && \
    pip install --no-cache-dir --upgrade pip setuptools wheel && \
    pip install --no-cache-dir \
    datasets \
    huggingface-hub "protobuf<4" "click<8.1"

# Custom added
RUN pip install onnxruntime-gpu

RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

WORKDIR $HOME/app

RUN git clone https://github.com/comfyanonymous/ComfyUI . && \
    pip install xformers --no-cache-dir -r requirements.txt --extra-index-url https://download.pytorch.org/whl/cu121

RUN echo "Done.  Make sure to run the script to download the models into the models/ volume, or just use the ComfyUI Mananger to download what you need."

CMD ["python", "main.py", "--listen", "0.0.0.0", "--port", "7860", "--output-directory", "output"]