import json
import boto3
import os

dynamodb = boto3.resource("dynamodb")
s3_client = boto3.client("s3")
table = dynamodb.Table(os.environ["DYNAMODB_TABLE"])


# S3イベントの構造
# https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/notification-content-structure.html
def lambda_handler(event, context):
    print("Received event:", json.dumps(event, indent=2))

    for record in event.get("Records", []):
        s3_info = record["s3"]
        bucket = s3_info["bucket"]["name"]
        key = s3_info["object"]["key"]

        # S3オブジェクトのメタ情報を取得（LastModified）
        response = s3_client.head_object(Bucket=bucket, Key=key)
        last_modified = response["LastModified"].isoformat()

        # PutItem実行（user-idは固定または拡張で対応）
        item = {
            "user-id": "default-user",  # 本来はS3イベントから取得する想定
            "file-name": key,
            "last-modified": last_modified,
        }

        print("Putting item to DynamoDB:", item)
        table.put_item(Item=item)

    return {"statusCode": 200, "body": "Success"}
