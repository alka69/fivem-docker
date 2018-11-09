FROM alpine:latest

ARG PROJECT_NAME="harlem-bay-server"
ARG BUILD_VERSION="1.0.0-snapshot"
ARG FM_VERSION="807-a33d6db066568046a9a99b14b0fccb03bb978e2f"

LABEL FIVEM_VERSION=${FM_VERSION} \
	VERSION=${BUILD_VERSION} \
	LABEL="${PROJECT_NAME}-v${BUILD_VERSION}"

RUN if [ -z "${FM_VERSION}" ]; then (&>2 echo "Argument FM_VERSION is not set."); exit 1; else : ; fi

WORKDIR /server

RUN apk update && apk upgrade && \
  apk add bash curl gettext

RUN curl --silent https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/${FM_VERSION}/fx.tar.xz --output fx.tar.xz && \
    tar xf fx.tar.xz && \
    rm -rf /var/cache/apk/*
    

CMD envsubst < /dependencies/template.cfg > instance.cfg | cp /dependencies/*.dll ./ && export MONO_TLS_PROVIDER=legacy && sh run.sh +exec instance.cfg 
