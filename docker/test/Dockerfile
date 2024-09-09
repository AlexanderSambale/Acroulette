
ARG IMAGE=debian:12.6-slim
FROM $IMAGE AS flutter-sdk

RUN apt-get update \
  && apt-get -y --no-install-recommends install \
  ca-certificates \
  # flutter start
  file \
  curl \
  git \
  unzip \
  xz-utils \
  zip \
  libglu1-mesa \
  ## flutter to run linux packages start
  clang \
  cmake \
  ninja-build \
  pkg-config \
  libgtk-3-dev \
  liblzma-dev \
  libstdc++-12-dev \
  ## flutter to run linux packages end
  # flutter end
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

FROM flutter-sdk

ENV FLUTTER_VERSION=3.22.2
ENV FLUTTER_HOME="/root/.flutter-sdk"
ENV PATH=$PATH:$FLUTTER_HOME/bin

# Download and extract Flutter SDK
RUN mkdir -p $FLUTTER_HOME \
  && cd $FLUTTER_HOME \
  && curl --fail --remote-time --silent --location -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz \
  && tar xf flutter_linux_${FLUTTER_VERSION}-stable.tar.xz --strip-components=1 \
  && rm flutter_linux_${FLUTTER_VERSION}-stable.tar.xz

RUN flutter precache
RUN flutter --disable-analytics
RUN yes | flutter doctor --android-licenses

RUN apt-get update \
  && apt-get -y --no-install-recommends install \
  libsqlite3-dev
