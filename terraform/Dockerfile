FROM alpine:latest as base
ENV TERRAFORM_VERSION=0.10.6
RUN apk update

FROM base as build
RUN apk add --no-cache ca-certificates openssl unzip wget \
    && cd /tmp \
    && wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/tmp 

FROM base as release 
RUN rm -rf /tmp/* \
    && rm -rf /var/cache/apk/* \
    && rm -rf /var/tmp/*
COPY --from=build /usr/tmp /usr/bin
ENTRYPOINT [ "/usr/bin/terraform" ]
CMD ["--help"]