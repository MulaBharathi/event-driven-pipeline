import boto3
import pymysql
import os
from datetime import datetime, timedelta

def lambda_handler(event, context):
    # Connect to RDS MySQL
    conn = pymysql.connect(
        host=os.environ['DB_HOST'],
        user=os.environ['DB_USER'],
        password=os.environ['DB_PASS'],
        db=os.environ['DB_NAME'],
        connect_timeout=5
    )
    cursor = conn.cursor()

    # Query summary (yesterday's data)
    yesterday = (datetime.utcnow() - timedelta(days=1)).strftime('%Y-%m-%d')
    cursor.execute("SELECT COUNT(*), AVG(value) FROM events WHERE DATE(timestamp) = %s", (yesterday,))
    count, avg = cursor.fetchone()

    report = f"Summary for {yesterday}:\nTotal Records: {count}\nAverage Value: {avg:.2f}"
    
    # Send email via SES
    ses = boto3.client('ses')
    ses.send_email(
        Source=os.environ['EMAIL_FROM'],
        Destination={'ToAddresses': [os.environ['EMAIL_TO']]},
        Message={
            'Subject': {'Data': f'Daily Report - {yesterday}'},
            'Body': {'Text': {'Data': report}}
        }
    )

    cursor.close()
    conn.close()
    
    return {"status": "Report sent"}

