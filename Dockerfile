ARG JAVA_VERSION=11

FROM amazoncorretto:$JAVA_VERSION

ENV RAM_MAX=6G
ENV RAM_MIN=4G

RUN mkdir -p /minecraft/data \
    && yum install -y unzip curl jq \
    && yum clean all \
    && rm -rf /var/cache/yum

WORKDIR /minecraft

ARG MINECRAFT_VERSION=1.16.5
ARG FORGE_VERSION=36.1.2
ARG PACK_NAME=atm-sky
ARG PACK_VERSION=1.0.9
ARG DOWNLOAD_URL=http://10.0.0.35:8000/SIMPLE-SERVER-FILES-1.0.9.zip
ARG PROJECTID_IGNORE

ENV DOWNLOAD_URL=$DOWNLOAD_URL
ENV FORGE_VERSION=$MINECRAFT_VERSION-$FORGE_VERSION
ENV PROJECTID_IGNORE=$PROJECTID_IGNORE
ENV RAM_MAX=4G
ENV RAM_MIN=1G

LABEL MINECRAFT_VERSION=$MINECRAFT_VERSION \
      FORGE_VERSION=$FORGE_VERSION \
      PACK_NAME=$PACK_NAME \
      PACK_VERSION=$PACK_VERSION

COPY entrypoint.sh prepare.sh /minecraft/

RUN echo "Downloading server files from ${DOWNLOAD_URL}" \
    && curl -sSL "${DOWNLOAD_URL}" -o serverfiles.zip \
    && unzip serverfiles.zip \
    && rm serverfiles.zip \
    && bash prepare.sh

RUN echo "Download Forge version ${FORGE_VERSION}" \
    && curl -sSL "http://files.minecraftforge.net/maven/net/minecraftforge/forge/${FORGE_VERSION}/forge-${FORGE_VERSION}-installer.jar" -o forge-installer.jar \
    && java -jar forge-installer.jar --installServer \
    && rm forge-installer.jar forge-installer.jar.log

ENTRYPOINT ["/bin/bash"]
CMD ["entrypoint.sh"]
