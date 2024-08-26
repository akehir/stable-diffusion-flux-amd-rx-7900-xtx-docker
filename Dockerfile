################################################################
# sudo docker build . --tag sd-webui-forge
# sudo docker run -it --network=host --device=/dev/kfd --device=/dev/dri --group-add=video --ipc=host --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v ./models:/SD/stable-diffusion-webui-forge/models/ -v ./repositories:/SD/stable-diffusion-webui-forge/repositories/ -v ./extensions:/SD/stable-diffusion-webui-forge/extensions/ -v ./outputs:/SD/stable-diffusion-webui-forge/outputs/ sd-webui-forge
################################################################

FROM rocm/pytorch:rocm6.2_ubuntu22.04_py3.10_pytorch_release_2.3.0

## Container
RUN mkdir /SD

## Clone SD
WORKDIR /SD
RUN git clone https://github.com/lllyasviel/stable-diffusion-webui-forge

WORKDIR /SD/stable-diffusion-webui-forge

## Activate VENV / Setup ENV
RUN python -m venv venv --system-site-packages
RUN . venv/bin/activate
ENV PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python

## Install Dependencies
RUN pip install -r requirements_versions.txt
RUN pip install requests==2.29.0

EXPOSE 7860/tcp

## Fix for "detected dubious ownership in repository" by rom1win.
RUN git config --global --add safe.directory '*'

CMD python launch.py --listen --disable-safe-unpickle --no-half-vae --no-half --precision full
