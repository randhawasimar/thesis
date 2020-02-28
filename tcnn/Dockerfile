FROM caffe:cuda-10.2

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/local/bin/tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini.asc /usr/local/bin/tini.asc
RUN chmod +x /usr/local/bin/tini

COPY . /workspace/
RUN wget -O tcnn3.caffemodel.tar https://storage.googleapis.com/tcnn-caffemodels/tcnn3.caffemodel.tar && tar -xvf tcnn3.caffemodel.tar
RUN mkdir /workspace/data/
RUN mkdir /workspace/examples/
RUN mkdir /model/
WORKDIR /workspace
ENTRYPOINT ["tini", "--"]
CMD ./run.sh
