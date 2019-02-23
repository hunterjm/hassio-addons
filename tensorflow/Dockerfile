ARG BUILD_FROM="homeassistant/amd64-base-python:3.7"
FROM $BUILD_FROM

ARG TENSORFLOW_VERSION="1.13.0-rc2"
ARG BAZEL_VERSION="0.21.0"
ARG HDF5_VERSION="1.8.21"
ENV JAVA_HOME="/usr/lib/jvm/java-1.8-openjdk"
# ENV EXTRA_BAZEL_ARGS="--jobs 4"

WORKDIR /usr/src
RUN apk add --no-cache \
        freetype libpng libjpeg-turbo musl openblas \
        g++ make libc6-compat \
    && apk add --no-cache --virtual=.build-dependencies \
        git cmake curl freetype-dev libjpeg-turbo-dev libpng-dev \
        linux-headers musl-dev openblas-dev openjdk8 zip patch \
        autoconf automake libtool file sed ca-certificates python \
    && curl -SL https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8/hdf5-$HDF5_VERSION/src/hdf5-$HDF5_VERSION.tar.gz | tar xzf - \
    && cd /usr/src/hdf5-$HDF5_VERSION \
    && autoreconf -f -i \
    && ./configure --prefix=/usr/local \
    && make \
    && make install \
    && cd /usr/src \
    && rm -rf /usr/src/hdf5-$HDF5_VERSION \
    && curl -SLO https://raw.githubusercontent.com/davido/bazel-alpine-package/master/david@ostrovsky.org-5a0369d6.rsa.pub \
    && mv david@ostrovsky.org-5a0369d6.rsa.pub /etc/apk/keys/david@ostrovsky.org-5a0369d6.rsa.pub \
    && curl -SLO https://github.com/davido/bazel-alpine-package/releases/download/$BAZEL_VERSION/bazel-$BAZEL_VERSION-r0.apk \
    && apk add bazel-$BAZEL_VERSION-r0.apk \
    && pip3 install --no-cache-dir wheel six numpy \
    && pip3 install --no-cache-dir --no-deps keras_applications==1.0.5 keras_preprocessing==1.0.3 \
    && git clone -b v$TENSORFLOW_VERSION --depth 1 https://github.com/tensorflow/tensorflow \
    && cd /usr/src/tensorflow \
    && sed -i -e '/define TF_GENERATE_BACKTRACE/d' tensorflow/core/platform/default/stacktrace.h \
    && sed -i -e '/define TF_GENERATE_STACKTRACE/d' tensorflow/core/platform/stacktrace_handler.cc \
    && PYTHON_BIN_PATH=/usr/local/bin/python3 PYTHON_LIB_PATH=/usr/local/lib/python3.7/site-packages \
        CC_OPT_FLAGS="-march=native" TF_NEED_JEMALLOC=1 TF_CUDA_CLANG=0 TF_NEED_GCP=0 TF_NEED_HDFS=0 \
        TF_NEED_S3=0 TF_ENABLE_XLA=0 TF_NEED_GDR=0 TF_NEED_VERBS=0 TF_CUDA_CLANG=0 TF_NEED_ROCM=0 \
        TF_NEED_OPENCL_SYCL=0 TF_NEED_OPENCL=0 TF_NEED_CUDA=0 TF_NEED_MPI=0 TF_NEED_IGNITE=0 \
        python3 configure.py \
    && bazel build --config=opt --cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" \
        //tensorflow/tools/pip_package:build_pip_package \
    && ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /usr/src/tensorflow_pkg \
    && cd /usr/src \
    && rm -rf /usr/src/tensorflow \
    && rm -f /usr/bin/bazel \
    && pip3 uninstall -y wheel keras_applications keras_preprocessing \
    && rm -f /usr/src/*.zip \
    && rm -rf /root/.cache \
    && rm -rf /root/.keras \
    && apk del .build-dependencies

# Copy data
COPY run.sh /
RUN chmod a+x /run.sh

WORKDIR /data
CMD ["/run.sh"]