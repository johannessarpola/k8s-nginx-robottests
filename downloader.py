import os
from minio import Minio
import urllib3
import shutil


MINIO_URL = os.getenv('MINIO_URL', "minio:9000")
MINIO_ACCESS_KEY = os.getenv('MINIO_ACCESS_KEY')
MINIO_SECRET_KEY = os.getenv('MINIO_SECRET_KEY')
DESTINATION_FILE = os.getenv('DESTINATION_FOLDER', "/app/html/index.html")

def main():
    httpClient = urllib3.PoolManager(
                timeout=urllib3.Timeout.DEFAULT_TIMEOUT,
                        cert_reqs='CERT_REQUIRED',
                        ca_certs='/certs/ca.crt',
                        retries=urllib3.Retry(
                            total=5,
                            backoff_factor=0.2,
                            status_forcelist=[500, 502, 503, 504]
                        )
            )


    client = Minio(
        MINIO_URL,
        access_key=MINIO_ACCESS_KEY,
        secret_key=MINIO_SECRET_KEY,
        secure=True,
        http_client=httpClient
    )
    
    bucket_name = "robot-reports"
    downloaded_filename = "report.html"
    remote_file_name = "report.html"

    found = client.bucket_exists(bucket_name)
    if not found:
        client.make_bucket(bucket_name)
    else:
        print(f"Bucket {bucket_name} already exists")

    client.fget_object(bucket_name, remote_file_name, downloaded_filename)
    
    print(
        f"'{remote_file_name}' is successfully downloades as "
        f"object '{downloaded_filename}' from bucket '{bucket_name}'."
    )

    shutil.copyfile(downloaded_filename, DESTINATION_FILE)

    print(f"Copied {downloaded_filename} to {DESTINATION_FILE}")


if __name__ == "__main__":
    main()