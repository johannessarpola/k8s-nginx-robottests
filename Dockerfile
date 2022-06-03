FROM mcr.microsoft.com/playwright:v1.22.0-focal

USER root

RUN apt-get update
RUN apt-get install -y python3-pip

ADD run.sh /home/pwuser/run.sh
RUN chmod +x /home/pwuser/run.sh

USER pwuser

RUN python3 -m pip install --user robotframework
RUN python3 -m pip install --user robotframework-browser

# Upload to minio
RUN python3 -m pip install --user install minio

RUN ~/.local/bin/rfbrowser init

ENV NODE_PATH=/usr/lib/node_modules
ENV PATH="/home/pwuser/.local/bin:${PATH}"

WORKDIR /home/pwuser/
ADD uploader.py .
ADD tests tests

CMD ["./run.sh"]

# Upload the report somehow to somewhere