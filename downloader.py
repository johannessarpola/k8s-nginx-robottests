import os
from minio import Minio
import urllib3
import shutil


MINIO_URL = os.getenv('MINIO_URL', "minio:9000")
MINIO_ACCESS_KEY = os.getenv('MINIO_ACCESS_KEY')
MINIO_SECRET_KEY = os.getenv('MINIO_SECRET_KEY')
DESTINATION_FOLDER = os.getenv('DESTINATION_FOLDER', "/app/html/")

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
    remote_file_names = ["report.html", "log.html"]

    file_renames = {
        "report.html" : "index.html",
    }

    found = client.bucket_exists(bucket_name)
    if not found:
        client.make_bucket(bucket_name)
    else:
        print(f"Bucket {bucket_name} already exists")

    for file_name in remote_file_names:
        client.fget_object(bucket_name, file_name, file_name)
        print(
            f"'{file_name}' is successfully downloades as "
            f"object '{file_name}' from bucket '{bucket_name}'."
        )

        destination_file = os.path.join(DESTINATION_FOLDER, file_name)
        if file_name in file_renames:
            destination_file = os.path.join(DESTINATION_FOLDER, file_renames.get(file_name))
        
        shutil.copyfile(file_name, destination_file)
        print(f"Copied {file_name} to {destination_file}")

if __name__ == "__main__":
    main()