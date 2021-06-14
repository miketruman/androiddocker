# androiddocker

docker build -t androiddocker .
xhost +
docker run -ti --rm -e DISPLAY=$(DISPLAY) --privileged -v /tmp/.X11-unix:/tmp/.X11-unix androiddocker
xhost -
