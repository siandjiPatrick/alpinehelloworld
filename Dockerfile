#Grab the latest alpine image
FROM alpine:latest

# Install python and pip
RUN apk add --no-cache --update python3 py3-pip bash
ADD ./webapp/requirements.txt /tmp/requirements.txt

RUN mkdir ~/my_env/
RUN python3 -m venv ~/my_env/venv
RUN source ~/my_env/venv/bin/activate

# Install dependencies
RUN  ~/my_env/venv/bin/pip install --no-cache-dir -q -r /tmp/requirements.txt

# Add our code
ADD ./webapp /opt/webapp/
WORKDIR /opt/webapp

# Expose is NOT supported by Heroku
# EXPOSE 5000 		

# Run the image as a non-root user
RUN adduser -D myuser
USER myuser

# Run the app.  CMD is required to run on Heroku
# $PORT is set by Heroku			
CMD ~/my_env/venv/bin/gunicorn --bind 0.0.0.0:$PORT wsgi 

