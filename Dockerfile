FROM golang:alpine@sha256:47d337594bd9e667d35514b241569f95fb6d95727c24b19468813d596d5ae596 AS go-builder

WORKDIR /usr/src/app

RUN apk add --update \
        curl \
        gcc \
        git \
        make \
        musl-dev

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .
RUN go build -o /app


FROM alpine

# Install packages required by the image
RUN apk add --update \
        bash \
        ca-certificates \
        coreutils \
        curl \
        jq \
        openssl \
    && rm /var/cache/apk/*

COPY --from=go-builder /app ./

CMD [ "./app" ]