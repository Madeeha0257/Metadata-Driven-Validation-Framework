

USE HospitalManagementDB;
GO


-- Patient : First_Name


INSERT INTO ValidationMetadata
(
ErrorCode,
SchemaName,
TableName,
ColumnName,
PKColumn,
CheckNull,
CheckEmpty,
MinLengthValue,
DomainValues,
BeforeYearValue,
MinValue,
MaxValue,
CompareColumn,
Operator,
ParentTable,
ParentColumn,
CheckEmail,
CheckNumeric,
CheckFutureDate,
CheckSpecialChars
)
VALUES
(
'ER01',
'hospital',
'Patient',
'First_Name',
'Patient_ID',
'YES',
'YES',
3,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
'NO',
'NO',
'NO',
'YES'
);


-- Patient : Gender


INSERT INTO ValidationMetadata
VALUES
(
'ER02',
'hospital',
'Patient',
'Gender',
'Patient_ID',
'NO',
'NO',
NULL,
'Male,Female',
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
'NO',
'NO',
'NO',
'NO'
);


-- Patient : DOB


INSERT INTO ValidationMetadata
VALUES
(
'ER03',
'hospital',
'Patient',
'DOB',
'Patient_ID',
'NO',
'NO',
NULL,
NULL,
1900,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
'NO',
'NO',
'YES',
'NO'
);


-- Patient : Phone


INSERT INTO ValidationMetadata
VALUES
(
'ER04',
'hospital',
'Patient',
'Phone',
'Patient_ID',
'NO',
'NO',
10,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
'NO',
'YES',
'NO',
'NO'
);


-- Doctor : Experience


INSERT INTO ValidationMetadata
VALUES
(
'ER05',
'hospital',
'Doctor',
'Experience_Years',
'Doctor_ID',
'YES',
'NO',
NULL,
NULL,
NULL,
0,
60,
NULL,
NULL,
NULL,
NULL,
'NO',
'NO',
'NO',
'NO'
);


-- Admission : Admission_Date vs Discharge_Date


INSERT INTO ValidationMetadata
VALUES
(
'ER06',
'hospital',
'Admission',
'Admission_Date',
'Admission_ID',
'NO',
'NO',
NULL,
NULL,
NULL,
NULL,
NULL,
'Discharge_Date',
'>',
NULL,
NULL,
'NO',
'NO',
'NO',
'NO'
);


-- Doctor : Department_ID (Foreign Key)


INSERT INTO ValidationMetadata
VALUES
(
'ER07',
'hospital',
'Doctor',
'Department_ID',
'Doctor_ID',
'NO',
'NO',
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
'Department',
'Department_ID',
'NO',
'NO',
'NO',
'NO'
);


-- Doctor : Email


INSERT INTO ValidationMetadata
VALUES
(
'ER08',
'hospital',
'Doctor',
'Email',
'Doctor_ID',
'NO',
'NO',
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
'YES',
'NO',
'NO',
'NO'
);


-- Bill : Payment_Status


INSERT INTO ValidationMetadata
VALUES
(
'ER09',
'hospital',
'Bill',
'Payment_Status',
'Bill_ID',
'NO',
'NO',
NULL,
'PAID,PENDING',
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
'NO',
'NO',
'NO',
'NO'
);


-- Bill : Total_Amount


INSERT INTO ValidationMetadata
VALUES
(
'ER10',
'hospital',
'Bill',
'Total_Amount',
'Bill_ID',
'NO',
'NO',
NULL,
NULL,
NULL,
0,
100000,
NULL,
NULL,
NULL,
NULL,
'NO',
'NO',
'NO',
'NO'
);


-- Appointment : Appointment_Date


INSERT INTO ValidationMetadata
VALUES
(
'ER11',
'hospital',
'Appointment',
'Appointment_Date',
'Appointment_ID',
'NO',
'NO',
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
'NO',
'NO',
'YES',
'NO'
);


-- Department : Department_Name


INSERT INTO ValidationMetadata
VALUES
(
'ER12',
'hospital',
'Department',
'Department_Name',
'Department_ID',
'YES',
'YES',
3,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
'NO',
'NO',
'NO',
'YES'
);


-- Patient : Email


INSERT INTO ValidationMetadata
VALUES
(
'ER13',
'hospital',
'Patient',
'Email',
'Patient_ID',
'NO',
'NO',
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
'YES',
'NO',
'NO',
'NO'
);


-- Appointment : Patient_ID (Foreign Key)


INSERT INTO ValidationMetadata
VALUES
(
'ER14',
'hospital',
'Appointment',
'Patient_ID',
'Appointment_ID',
'NO',
'NO',
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
'Patient',
'Patient_ID',
'NO',
'NO',
'NO',
'NO'
);

-- Doctor : Phone

INSERT INTO ValidationMetadata
VALUES
(
'ER15',
'hospital',
'Doctor',
'Phone',
'Doctor_ID',
'NO',
'NO',
10,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
'NO',
'YES',
'NO',
'NO'
);

-- Bill : Patient_ID

INSERT INTO ValidationMetadata
VALUES
(
'ER16',
'hospital',
'Bill',
'Patient_ID',
'Bill_ID',
'NO',
'NO',
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
'Patient',
'Patient_ID',
'NO',
'NO',
'NO',
'NO'
);

-- Admission : Doctor_ID

INSERT INTO ValidationMetadata
VALUES
(
'ER17',
'hospital',
'Admission',
'Doctor_ID',
'Admission_ID',
'NO',
'NO',
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
'Doctor',
'Doctor_ID',
'NO',
'NO',
'NO',
'NO'
);

GO

SELECT * FROM ValidationMetadata;