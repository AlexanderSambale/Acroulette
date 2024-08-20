
ARG IMAGE=mcr.microsoft.com/devcontainers/base:bookworm
FROM $IMAGE as android-sdk

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
  openjdk-17-jdk \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Command line tools only
# https://developer.android.com/studio/index.html
ENV ANDROID_SDK_TOOLS_VERSION=11076708
ENV ANDROID_SDK_TOOLS_CHECKSUM=2d2d50857e4eb553af5a6dc3ad507a17adf43d115264b1afc116f95c92e5e258
ENV ANDROID_HOME="/opt/android-sdk-linux"
ENV ANDROID_SDK_ROOT=$ANDROID_HOME
ENV ANDROID_CLI_TOOLS=${ANDROID_HOME}/cmdline-tools/${ANDROID_SDK_TOOLS_VERSION}
ENV PATH=$PATH:$ANDROID_CLI_TOOLS:$ANDROID_CLI_TOOLS/bin:$ANDROID_HOME/platform-tools

# Download and unzip Android commandline SDK Tools
RUN curl -s https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS_VERSION}_latest.zip > /tools.zip \
  && echo "$ANDROID_SDK_TOOLS_CHECKSUM /tools.zip" | sha256sum -c \
  && mkdir -p /tmp/cli-tools \
  && unzip -qq /tools.zip -d /tmp/cli-tools \
  && mkdir -p $ANDROID_CLI_TOOLS \
  && mv /tmp/cli-tools/cmdline-tools/* ${ANDROID_CLI_TOOLS} \
  && rm -v /tools.zip

ENV ANDROID_PLATFORM_VERSION=34
ENV ANDROID_BUILD_TOOLS_VERSION=34.0.0

RUN yes | sdkmanager \
  --sdk_root=${ANDROID_SDK_ROOT} \
  "platforms;android-$ANDROID_PLATFORM_VERSION" \
  "build-tools;$ANDROID_BUILD_TOOLS_VERSION" \
  "platform-tools"

WORKDIR $ANDROID_SDK_ROOT
RUN curl -O https://github.com/google/bundletool/releases/download/1.17.1/bundletool-all-1.17.1.jar

FROM android-sdk

ENV FLUTTER_VERSION=3.22.3
ARG USERNAME=vscode
ENV FLUTTER_HOME="/home/${USERNAME}/.flutter-sdk"
ENV PATH=$PATH:$FLUTTER_HOME/bin

# Download and extract Flutter SDK
RUN mkdir -p $FLUTTER_HOME \
  && cd $FLUTTER_HOME \
  && curl --fail --remote-time --silent --location -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz \
  && tar xf flutter_linux_${FLUTTER_VERSION}-stable.tar.xz --strip-components=1 \
  && rm flutter_linux_${FLUTTER_VERSION}-stable.tar.xz

RUN chown -R $USERNAME:$USERNAME $FLUTTER_HOME

USER $USERNAME
RUN flutter precache
RUN flutter --disable-analytics
RUN yes | flutter doctor --android-licenses

USER root
RUN apt-get update \
  && apt-get -y --no-install-recommends install \
  libsqlite3-dev
USER $USERNAME
