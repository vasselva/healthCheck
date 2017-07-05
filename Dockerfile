FROM node:boron

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install
RUN [ "cpan" , "MIME::Lite" ]
RUN [ "cpan" , "MIME::Entity" ]
RUN ln -sf /usr/src/app/node_modules/phantomjs/bin/phantomjs /usr/local/bin/phantomjs
RUN ln -sf /usr/src/app/node_modules/phantomjs/bin/phantomjs /usr/bin/phantomjs
RUN ln -sf /usr/src/app/node_modules/casperjs/bin/casperjs /usr/local/bin/casperjs
RUN ln -sf /usr/src/app/node_modules/casperjs/bin/casperjs /usr/bin/casperjs
RUN ln -sf /usr/src/app/node_modules/jasmine-node/bin/jasmine-node /usr/local/bin/jasmine-node
RUN ln -sf /usr/src/app/node_modules/jasmine-node/bin/jasmine-node /usr/bin/jasmine-node

# Bundle app source
#COPY . /usr/src/app
WORKDIR /usr/src/app/test

#CMD [ "/usr/bin/casperjs", "test" , "/usr/src/app/ebs.js" ]
#ENTRYPOINT [ "/usr/bin/casperjs", "test" , "/usr/src/app/test/ebs.js" ]
ENTRYPOINT [ "sh" ]

