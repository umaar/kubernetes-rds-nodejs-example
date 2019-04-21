FROM node:10.15.3-alpine

RUN mkdir /runner
ADD . /runner

WORKDIR /runner

RUN npm install

RUN addgroup -S group1 && adduser -S user1 -u 1001 -G group1

RUN chown -R user1:group1 /runner

USER 1001

EXPOSE  3000

CMD [ "npm", "run", "migrate-and-start" ]
