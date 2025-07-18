
# 📊 Event-Driven Data Pipeline on AWS

This project showcases an **event-driven data processing pipeline** using AWS services. When a `.csv` file is uploaded to S3, it triggers a Lambda function to process and store the data in Amazon RDS (MySQL). A second Lambda function runs daily to send a **summary report via email using Amazon SES**.

✅ The entire infrastructure is provisioned using **Terraform**  
✅ CI/CD is handled using **GitHub Actions**



## ⚙️ Technologies Used

- **Amazon S3** – File trigger (CSV upload)
- **AWS Lambda (Python)** – Serverless processing
- **Amazon RDS (MySQL)** – Relational database
- **Amazon SES** – Email notifications
- **Terraform** – Infrastructure as Code
- **GitHub Actions** – CI/CD deployment
- **EventBridge** – Daily report scheduling

## 🚀 How It Works

1. Upload a `.csv` file to S3
2. **S3 triggers Lambda 1** (`data_processor.py`)  
   → Parses the file and stores the data in **RDS**
3. **Lambda 2** (`report_generator.py`) runs daily  
   → Queries RDS and sends a summary email via **SES**

🛠️ How to Deploy
Step 1 – Set up Terraform

```
cd terraform
terraform init
terraform apply
```

Step 2 – Configure GitHub Actions
In GitHub, go to:
Settings > Secrets and Variables > Actions > Repository Secrets


AWS_ACCESS_KEY_ID

AWS_SECRET_ACCESS_KEY
