FROM bvlc/caffe:cpu
COPY . /workspace/
RUN wget -O tcnn3.caffemodel.tar https://storage.googleapis.com/tcnn-caffemodels/tcnn3.caffemodel.tar && tar -xvf tcnn3.caffemodel.tar
RUN mkdir /workspace/data/
RUN mkdir /workspace/examples/
RUN mkdir /model/
WORKDIR /workspace
CMD ./run.sh
