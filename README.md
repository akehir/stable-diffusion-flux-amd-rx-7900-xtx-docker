# Stable Diffusion Webui Forge (with FLUX) running via Docker on AMD RX 7900XTX (Linux)

This repo is a small demo of how to run stable diffusion webui forge via docker / ROCM on an AMD GPU.
The host system doesn't need ROCM installed, it's sufficient to have the open source AMD drivers (mesa), and the AMD Kernel modules.
Therefore, any more or less current Linux with Docker installed should work fine.

I'm running this on Debian Testing (Trixie), and it's also working on Debian Stable (Bookworm).

## Getting started

### Downloading the Models
Download the models you want to use and put them into the "models" directory.

### Docker-Compose
To run the container with 1 command via docker-compose, just use:
```
docker-compose up --build
```

Access the UI under http://localhost:7860/ .


### Docker
Without docker compose, you can also directly leverage docker to build and run the container.
```
sudo docker build . --tag sd-webui-forge
sudo docker run -it --network=host --device=/dev/kfd --device=/dev/dri --group-add=video --ipc=host --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v ./models:/SD/stable-diffusion-webui-forge/models/ -v ./repositories:/SD/stable-diffusion-webui-forge/repositories/ -v ./extensions:/SD/stable-diffusion-webui-forge/extensions/ -v ./outputs:/SD/stable-diffusion-webui-forge/outputs/ sd-webui-forge
```
Access the UI under http://localhost:7860/ .

### Podman
Unfortunately I haven't gotten this to run via podman (I assume podman doesn't play nicely with the hardware access). Running the container via podman yields the following error:
> RuntimeError: Your device does not support the current version of Torch/CUDA! Consider download another version

## Issues
> RuntimeError: Your device does not support the current version of Torch/CUDA! Consider download another version

This is most likely caused by not having access to the graphics card via podman. Try running it as super user / via docker.
