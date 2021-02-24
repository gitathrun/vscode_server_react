# VSCode Server for React Development #

__Author: Teng Fu__

__Contact: teng.fu@teleware.com__

This is a vscode-server integrated docker image for React web app development.

## How to user ##

- docker cmd

```
sudo docker run -p 8889:3000 -v ${PWD}:/app tftwdockerhub/vscode_server_react:latest
```

- docker-compose

Ready the __docker-compose.yaml__ file in project directory, and use following cmd to startup the container.

```
sudo docker-compose up
```

After startup the container, wait for the console message pops out a link for coder platform, copy and pasty the link to browser.
This process will use github as authentication, by accept the requrest, you can access your vscode server in browser, in a remote machine now.
port 3000 is used for tunnel access of the development server when you debugging react app. Developer can directly use __npm start__ to debug the app.


Or use a specific port for debugging in vscode-server terminal such as following cmd, but in that case, developer has to make change to the port binding in 
docker cmd and docker-compose to make sure broswer can hit the correct debugging port.

```
PORT=8888 npm start
```
