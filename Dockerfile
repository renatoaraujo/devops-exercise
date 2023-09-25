FROM golang:1.21 AS builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o helloworld ./cmd/helloworld

FROM alpine:3.18

COPY --from=builder /app/helloworld /helloworld

CMD ["/helloworld"]
