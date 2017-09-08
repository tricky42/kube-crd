CGO_ENABLED=0 GOOS=linux go build -a -tags netgo -ldflags '-w' -o envcontroller .

docker build -t tricky42/envcontroller .
docker run -d -P tricky42/envcontroller