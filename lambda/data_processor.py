import json
import boto3
import pymysql
import os
import csv

s3 = boto3.client('s3')

def lambda_handler(event, context):
    bucket = event['Records'][0]['s3']['bucket']['name']
    file_key = event['Records'][0]['s3']['object']['key']
    
    # Download CSV file
    local_file = f"/tmp/{file_key}"
    s3.download_file(bucket, file_key, local_file)
    
    # Connect to RDS MySQL
    conn = pymysql.connect(
        host=os.environ['DB_HOST'],
        user=os.environ['DB_USER'],
        password=os.environ['DB_PASS'],
        db=os.environ['DB_NAME'],
        connect_timeout=5
    )
    cursor = conn.cursor()

    # Parse CSV and insert data
    with open(local_file, newline='') as csvfile:
        reader = csv.reader(csvfile)
        next(reader)  # Skip header
        for row in reader:
            cursor.execute("INSERT INTO events (name, value, timestamp) VALUES (%s, %s, %s)", row)
    
    conn.commit()
    cursor.close()
    conn.close()
    
    return {
        'statusCode': 200,
        'body': json.dumps('File processed successfully')
    }

