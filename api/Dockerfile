FROM golang:1.15

WORKDIR /go/src/api
COPY . .

RUN go get -d -v ./...
RUN go install -v ./...

CMD ["api"]