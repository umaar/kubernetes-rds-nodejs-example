NAME ?= form-builder/umar-dev

install:
	npm install

build:
	docker build -t $(NAME) .

bash: build
	docker run -it --rm --entrypoint /bin/bash $(NAME)

run: build
	docker run -i -t -p 3000:3000 -d $(NAME)

test:
	docker run --rm $(NAME) npm test

clean:
	rm -rf node_modules

kill:
	docker kill $(docker ps -q)


.PHONY: install build run test clean
