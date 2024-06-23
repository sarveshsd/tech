FROM golang:1.19-alpine AS build

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN go build -o main .

#Runner stage
FROM alpine:latest  

RUN apk --no-cache add ca-certificates

WORKDIR /root/
COPY --from=build /app/main .
COPY --from=build /app/.env .
EXPOSE 8080

CMD ["./main"]