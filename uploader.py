import os
from minio import Minio
import urllib3


MINIO_URL = os.getenv('MINIO_URL', "minio:9000")
MINIO_ACCESS_KEY = os.getenv('MINIO_ACCESS_KEY')
MINIO_SECRET_KEY = os.getenv('MINIO_SECRET_KEY')

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
        #access_key="noTI4ejOP8I9s99t",
        access_key=MINIO_ACCESS_KEY,
        #secret_key="OeSYaMg5yFAjUG5yjh8Pv60a1wcKNBBk",
        secret_key=MINIO_SECRET_KEY,
        secure=True,
        http_client=httpClient
    )
    
    bucket_name = "robot-reports"
    #file_name = "/home/pwuser/report.html"
    file_name = "report.html"
    destination_file_name = "report.html"

    # Make 'asiatrip' bucket if not exist.
    found = client.bucket_exists(bucket_name)
    if not found:
        client.make_bucket(bucket_name)
    else:
        print(f"Bucket {bucket_name} already exists")


    # Upload '/home/user/Photos/asiaphotos.zip' as object name
    # 'asiaphotos-2015.zip' to bucket 'asiatrip'.
    client.fput_object(
        bucket_name, destination_file_name, file_name,
    )
    print(
        f"'{file_name}' is successfully uploaded as "
        f"object '{destination_file_name}' to bucket '{bucket_name}'."
    )


if __name__ == "__main__":
    main()