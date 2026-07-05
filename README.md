# Metadata-Driven Data Validation Framework

A metadata-driven data validation framework built using **SQL Server** and **PowerShell**. Validation rules are stored in a metadata table, allowing new rules to be added without modifying the validation logic. The framework validates metadata, performs dynamic data validation, exports Excel reports, generates execution logs, and sends email notifications.

---

## Features

* Metadata-driven validation
* Dynamic SQL generation
* Metadata validation before execution
* Excel report generation
* Execution logging
* Email notifications
* PowerShell automation

---

## Technologies Used

* Microsoft SQL Server
* SQL Server Management Studio (SSMS)
* T-SQL
* PowerShell
* SQLServer PowerShell Module
* ImportExcel PowerShell Module

---

## Project Structure

```text
SQL/
├── 01_CreateDatabase.sql
├── 02_CreateTables.sql
├── 03_InsertSampleData.sql
├── 04_CreateValidationFramework.sql
├── 05_InsertValidationMetadata.sql
├── 06_RunMetadataValidation.sql
├── 07_RunValidation.sql
└── 09_TestInvalidMetadata.sql

Automation/
└── 08_ValidationAutomation.ps1

Sample_Reports/
├── SampleDataValidationReport.xlsx
├── SampleLogFile.txt
├── SampleMetadataValidationSuccessfulReport.xlsx
└── SampleMetadataValidationFailedReport.xlsx
```

---
## Prerequisites

Before running the project, ensure you have the following installed:

- Microsoft SQL Server (Developer or Express Edition)
- SQL Server Management Studio (SSMS)
- Windows PowerShell 5.1 or PowerShell 7+
- SQLServer PowerShell Module
- ImportExcel PowerShell Module

Install the required PowerShell modules using:

```powershell
Install-Module SqlServer
Install-Module ImportExcel
```

---

## How to Run

Ensure that all scripts are executed against the **HospitalManagementDB** database.

Execute the SQL scripts in the following order:

```text
01_CreateDatabase.sql
02_CreateTables.sql
03_InsertSampleData.sql
04_CreateValidationFramework.sql
05_InsertValidationMetadata.sql
06_RunMetadataValidation.sql
07_RunValidation.sql
```

To automate the complete validation process, execute:

```text
08_ValidationAutomation.ps1
```

## Gmail App Password Setup

The PowerShell automation script uses Gmail SMTP to send email notifications. Before running `08_ValidationAutomation.ps1`, configure the following values:

```powershell
$Username = "your-email@gmail.com"

$Password = ConvertTo-SecureString `
"<YOUR_GMAIL_APP_PASSWORD>" `
-AsPlainText -Force
```

### How to Generate a Gmail App Password

1. Enable **2-Step Verification** for your Google Account.
2. Visit **https://myaccount.google.com/security**.
3. Under **"How you sign in to Google"**, select **App passwords**.
4. Sign in again if prompted.
5. Choose:

   * **App:** Mail
   * **Device:** Other (Custom name)
6. Enter a name such as **Validation Framework** and click **Generate**.
7. Copy the generated 16-character App Password.
8. Replace `<YOUR_GMAIL_APP_PASSWORD>` in `08_ValidationAutomation.ps1` with the generated password.

> **Note:** Never commit your personal Gmail address or App Password to GitHub. Always replace them with placeholders before publishing your project.


---

## Testing Invalid Metadata

To verify metadata validation, execute:

```text
09_TestInvalidMetadata.sql
```

This script:

* Inserts invalid metadata rules
* Executes metadata validation
* Displays the detected configuration errors
* Removes the test metadata after execution

---

## Validation Rules

The framework supports:

* Null Check
* Empty Check
* Minimum Length
* Domain Validation
* Before Year Validation
* Minimum & Maximum Value
* Range Validation
* Column Comparison
* Foreign Key Validation
* Email Validation
* Numeric Validation
* Future Date Validation
* Special Character Validation

---

## Generated Reports

The framework automatically generates:
* Metadata Validation Report (.xlsx)
* Data Validation Report (.xlsx)
* Execution Log (.log)

The generated reports are available in the `Sample_Reports` folder as reference outputs.

---

## Future Scope

The framework can be extended with the following enhancements:

* Support for additional validation rules such as regular expressions, uniqueness checks, and custom business rules.
* Integration with multiple database platforms such as PostgreSQL, MySQL, and Oracle.
* Web-based dashboard for configuring validation rules and viewing reports.
* Scheduled automatic validation using Windows Task Scheduler or SQL Server Agent.
* Report history and audit trail for tracking validation results over time.
* Real-time email or messaging notifications for validation failures.
* Import and export of validation metadata using Excel or CSV files.
* Role-based access control for managing validation configurations.

---

