# thesis
## TCNN Parameters
### REQUIRED
* mount data directory at target: /workspace/data/
### OPTIONAL
* mount model directory at target: /model/
* env var for create_kth.sh script: RESIZE 

## Building TCNN container
docker build . -t tcnn-trainer

## Running TCNN container
docker run -v <data-directory-on-host>:/workspace/data/ tcnn-trainer
