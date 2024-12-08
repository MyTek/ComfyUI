# ComfyUI
Install ComfyUI with Traefik and host externally

This was pulled and revamped from https://github.com/krasamo/comfyui-docker

Make your folders for the docker volumes (data, models, code, custom_nodes, output).
`mkdir data models code custom_nodes output workflows`

Build the image -
`docker build --no-cache -t comfyui:custom .`

Run the download_comfyui-manager.sh file -
`download_comfyui-manager.sh`

Change the website address in the compose.
"traefik.http.routers.comfyui.rule=Host(`comfyui.example.com`)"

Run the compose.
`docker compose up -d`

Check the output directory for generated images.
`./output`

Enjoy.
