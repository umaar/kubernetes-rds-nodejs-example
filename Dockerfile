FROM node:12.4.0-alpine

RUN mkdir /runner

ADD . /runner

WORKDIR /runner

RUN npm install

RUN addgroup -S group1 && adduser -S user1 -u 1001 -G group1

# TODO: This is slow because node_modules is massive. Change ordering so this happens before npm install, however watch out as npm install will install modules as root
RUN chown -R user1:group1 /runner

USER 1001

EXPOSE  3000

CMD [ "npm", "run", "migrate-and-start" ]
