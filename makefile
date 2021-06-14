all:
	docker build -t androidemulator_androidemulator .
	xhost +
	docker run -ti --rm -e DISPLAY=$(DISPLAY) --privileged -v /tmp/.X11-unix:/tmp/.X11-unix androidemulator_androidemulator
	xhost -
