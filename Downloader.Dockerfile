FROM python:3.9-alpine

ENV PROJ_DIR="/app"
ENV LOG_FILE="${PROJ_DIR}/app.log"
ENV CRON_SPEC="* * * * *" 

WORKDIR ${PROJ_DIR}

RUN pip install install minio

ADD downloader.py app.py

RUN echo "${CRON_SPEC} python ${PROJ_DIR}/app.py >> ${LOG_FILE} 2>&1" > ${PROJ_DIR}/crontab

RUN touch ${LOG_FILE}

RUN crontab ${PROJ_DIR}/crontab
RUN crontab -l

CMD crond  && tail -f ${LOG_FILE}
