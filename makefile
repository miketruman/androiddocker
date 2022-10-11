all:
	docker build -t androidemulator_androidemulator --build-arg ABIS=google_apis --build-arg ANDROID=android-25 .
	xhost +
	docker run -ti --rm -e DISPLAY=$(DISPLAY) --privileged -v /tmp/.X11-unix:/tmp/.X11-unix miketruman/androiddocker
	xhost -
