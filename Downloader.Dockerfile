FROM python:3.9-slim
WORKDIR /app/
RUN pip install install minio

ADD downloader.py app.py

CMD ["python", "app.py"]