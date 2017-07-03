FROM node:boron

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app


# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install

# Bundle app source
COPY . /usr/src/app
ENV NODE_ENV=production

ADD ./wait.sh /usr/local/bin/wait.sh
RUN chmod +x /usr/local/bin/wait.sh
ADD ./start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

EXPOSE 3000

CMD [ "/usr/local/bin/start.sh" ]
