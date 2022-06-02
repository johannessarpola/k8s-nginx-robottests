FROM mcr.microsoft.com/playwright:v1.22.0-focal

USER root

RUN apt-get update
RUN apt-get install -y python3-pip

USER pwuser

RUN python3 -m pip install --user robotframework
RUN python3 -m pip install --user robotframework-browser

RUN ~/.local/bin/rfbrowser init

ENV NODE_PATH=/usr/lib/node_modules
ENV PATH="/home/pwuser/.local/bin:${PATH}"

WORKDIR /home/pwuser/
COPY tests .

CMD ["robot", "." ]

# Upload the report somehow to somewhere