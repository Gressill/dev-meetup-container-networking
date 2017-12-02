
net-tools.tar: ./docker-net-tools-image/Dockerfile
	docker build --build-arg http_proxy=${http_proxy} --tag net-tools:latest ./docker-net-tools-image && \
	docker save -o $@ net-tools:latest

clean:
	rm net-tools.tar
