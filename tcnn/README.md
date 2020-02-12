## Original source code
* Original source code at: https://github.com/v-andrearczyk/caffe-TCNN
### Updates in this fork
* Adapting the original code to work with any dataset in a parameterized fashion
* Dockerized the original runtime for portability
## TCNN Parameters
### REQUIRED
* mount data directory at target: `/workspace/data/`
### OPTIONAL
* mount model directory at target: `/model/`
* env var for create_kth.sh script: `RESIZE`

## Building TCNN container
```
docker build . -t tcnn-trainer
```

## Running TCNN container
```
docker run -v <data-directory-on-host>:/workspace/data/ tcnn-trainer
```
