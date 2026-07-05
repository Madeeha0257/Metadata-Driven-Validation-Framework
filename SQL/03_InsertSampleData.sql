-- Department
INSERT INTO hospital.Department
(Department_ID, Department_Name, Location)
VALUES
--Valid Data
(1, 'Cardiology', 'Block A'),
(2, 'Neurology', 'Block B'),
(3, 'Orthopedics', 'Block C'),
(4, 'Pediatrics', 'Block D'),
(5, 'Oncology', 'Block E'),
(6, 'Emergency', 'Ground Floor'),

-- Invalid Data
(7, NULL, 'Block G'),                -- Null Department Name
(8, '', 'Block H'),                  -- Empty Department Name
(9, 'Cardio@logy', 'Block I'),       -- Special Character
(999, 'Radiology', NULL);            -- Null Location (for completeness)

-- Doctor
INSERT INTO hospital.Doctor
(
    Doctor_ID,
    First_Name,
    Last_Name,
    Gender,
    Email,
    Phone,
    Experience_Years,
    Department_ID
)
VALUES
-- Valid Data
(1, 'Arjun', 'Sharma', 'Male', 'arjun.sharma@hospital.com', '9876543210', 12, 1),
(2, 'Priya', 'Nair', 'Female', 'priya.nair@hospital.com', '9876543211', 8, 2),
(3, 'Rahul', 'Verma', 'Male', 'rahul.verma@hospital.com', '9876543212', 15, 3),
(4, 'Sneha', 'Iyer', 'Female', 'sneha.iyer@hospital.com', '9876543213', 6, 4),
(5, 'David', 'Thomas', 'Male', 'david.thomas@hospital.com', '9876543214', 20, 5),
(6, 'Aisha', 'Khan', 'Female', 'aisha.khan@hospital.com', '9876543215', 9, 6),

-- Invalid Data
(7, NULL, 'Mehta', 'Male', 'rohan.mehta@hospital.com', '9876543216', 4, 7),                  -- NULL First_Name
(8, '', 'Joseph', 'Female', 'meera.joseph@hospital.com', '9876543217', 11, 8),                -- Empty First_Name
(9, 'Jo', 'Patel', 'Male', 'karan.patel@hospital.com', '9876543218', 7, 1),                   -- Min Length
(10, 'Divya@', 'Rao', 'Female', 'divya.rao@hospital.com', '9876543219', 5, 2),                -- Special Characters
(11, 'Amit', 'Singh', 'Unknown', 'amit.singh@hospital.com', '9876543220', 18, 3),             -- Invalid Domain
(12, 'Neha', 'Das', 'Female', 'neha.dashospital.com', '9876543221', 10, 4),                   -- Invalid Email
(13, 'Vikram', 'Gill', 'Male', 'vikram.gill@hospital.com', '98AB543210', 13, 5),              -- Non-Numeric Phone
(14, 'Sara', 'Ali', 'Female', 'sara.ali@hospital.com', '12345', -5, 999),                     -- Min Value + Short Phone + Invalid FK
(15, 'Joseph', 'Fernandes', 'Male', 'joseph.fernandes@hospital.com', '9876543224', 120, 2);   -- Max Value

-- Patient
INSERT INTO hospital.Patient
(
    Patient_ID,
    First_Name,
    Last_Name,
    Gender,
    DOB,
    Email,
    Phone,
    Blood_Group,
    Address
)
VALUES
-- Valid Data
(1,'Ananya','Reddy','Female','2000-05-12','ananya@email.com','9123456780','A+','Chennai'),
(2,'Mohit','Gupta','Male','1998-02-10','mohit@email.com','9123456781','B+','Bangalore'),
(3,'Fatima','Ahmed','Female','1995-09-19','fatima@email.com','9123456782','O+','Hyderabad'),
(4,'Riya','Paul','Female','2002-01-21','riya@email.com','9123456783','AB+','Kochi'),
(5,'Aditya','Roy','Male','1996-07-14','aditya@email.com','9123456784','A-','Delhi'),
(6,'Kavya','Menon','Female','2001-03-18','kavya@email.com','9123456785','B-','Chennai'),

-- Invalid Data
(7,NULL,'Kumar','Male','1993-11-02','harish@email.com','9123456786','O-','Madurai'),             -- NULL
(8,'','Shah','Female','1999-06-06','pooja@email.com','9123456787','AB-','Mumbai'),               -- Empty
(9,'A','Sethi','Male','1990-08-09','nitin@email.com','9123456788','A+','Pune'),                  -- Min Length
(10,'John@123','Das','Female','1997-12-22','ishita@email.com','9123456789','O+','Kolkata'),      -- Special Character
(11,'Varun','Bose','Unknown','2000-04-11','varun@email.com','9234567800','B+','Chennai'),        -- Invalid Domain
(12,'Sana','Mir','Female','1994-10-03','sanagmail.com','9234567801','A+','Mysuru'),              -- Invalid Email
(13,'Ajay','Nair','Male','1992-09-15','ajay@email.com','98AB567890','O+','Kozhikode'),           -- Non Numeric
(14,'Nisha','R','Female','1998-01-29','nisha@email.com','1234','AB+','Coimbatore'),              -- Short Phone
(15,'Yash','Kapoor','Male','1800-02-17','yash@email.com','9234567804','B+','Delhi'),             -- Before Year
(16,'Latha','S','Female','2035-11-11','latha@email.com','9234567805','O-','Trichy'),             -- Future DOB
(17,'Arav','Jain','Alien','1995-06-30',NULL,'9234567806','A+','Jaipur'),                         -- Invalid Domain + NULL Email
(18,'Maya','George','Female','1996-07-25','maya@email.com','9234567807','AB-',''),               -- Empty Address
(19,'Deepak','Rana','Male','1991-08-13','deepak@email.com','9234567808','A-','Dehradun'),
(20,'Zoya','Iqbal','Female','2001-12-05','zoya@email.com','9234567809','B-','Lucknow');

-- Appointment
INSERT INTO hospital.Appointment
(
    Appointment_ID,
    Patient_ID,
    Doctor_ID,
    Appointment_Date,
    Appointment_Time,
    Status
)
VALUES
-- Valid Data
(1,1,1,'2025-05-01','09:00','Completed'),
(2,2,2,'2025-05-02','10:00','Scheduled'),
(3,3,3,'2025-05-03','11:00','Cancelled'),
(4,4,4,'2025-05-04','12:00','Completed'),
(5,5,5,'2025-05-05','13:00','Scheduled'),
(6,6,6,'2025-05-06','14:00','Completed'),

-- Invalid Data
(7,999,1,'2025-05-07','09:30','Completed'),          -- Invalid Patient_ID
(8,1,999,'2025-05-08','10:30','Completed'),          -- Invalid Doctor_ID
(9,NULL,2,'2025-05-09','11:30','Completed'),         -- NULL Patient_ID
(10,3,NULL,'2025-05-10','12:30','Completed'),        -- NULL Doctor_ID
(11,4,4,DATEADD(YEAR,2,GETDATE()),'13:30','Completed'), -- Future Date
(12,5,5,'2025-05-12','14:30','Done'),               -- Invalid Domain
(13,6,6,'2025-05-13','15:30',''),                   -- Empty Status
(14,7,7,'2025-05-14','16:30',NULL),                 -- NULL Status
(15,8,8,'2025-05-15','17:30','Scheduled');

-- Admission
INSERT INTO hospital.Admission
(
    Admission_ID,
    Patient_ID,
    Doctor_ID,
    Room_Number,
    Admission_Date,
    Discharge_Date
)
VALUES
-- Valid Records
(1,1,1,'101','2025-01-10','2025-01-15'),
(2,2,2,'102','2025-02-05','2025-02-10'),
(3,3,3,'103','2025-03-01','2025-03-07'),
(4,4,4,'104','2025-04-11','2025-04-15'),
(5,5,5,'105','2025-05-20','2025-05-25'),

-- Invalid Records
(6,999,1,'106','2025-06-01','2025-06-05'),          -- Invalid Patient_ID
(7,1,999,'107','2025-06-10','2025-06-12'),          -- Invalid Doctor_ID
(8,NULL,2,'108','2025-06-15','2025-06-18'),         -- NULL Patient_ID
(9,3,NULL,'109','2025-06-20','2025-06-25'),         -- NULL Doctor_ID
(10,4,4,'','2025-07-01','2025-07-05'),              -- Empty Room Number
(11,5,5,NULL,'2025-07-10','2025-07-15'),            -- NULL Room Number
(12,6,6,'112','2025-08-15','2025-08-10'),           -- Admission > Discharge
(13,7,7,'113',DATEADD(YEAR,2,GETDATE()),DATEADD(YEAR,2,GETDATE()+5)), -- Future Date
(14,8,8,'114','2025-09-01','2025-09-05'),
(15,9,9,'115','2025-10-01','2025-10-06');

-- Bill
INSERT INTO hospital.Bill
(
    Bill_ID,
    Patient_ID,
    Bill_Date,
    Total_Amount,
    Payment_Status
)
VALUES
-- Valid Records
(1,1,'2025-05-01',2500,'PAID'),
(2,2,'2025-05-02',3200,'PENDING'),
(3,3,'2025-05-03',1800,'PAID'),
(4,4,'2025-05-04',7500,'PENDING'),
(5,5,'2025-05-05',6000,'PAID'),

-- Invalid Records
(6,999,'2025-05-06',3500,'PAID'),                   -- Invalid Patient_ID
(7,NULL,'2025-05-07',2800,'PAID'),                  -- NULL Patient_ID
(8,6,DATEADD(YEAR,2,GETDATE()),4200,'PAID'),        -- Future Date
(9,7,'2025-05-09',-100,'PAID'),                     -- Minimum Value
(10,8,'2025-05-10',2500000,'PAID'),                 -- Maximum Value
(11,9,'2025-05-11',5000,'Done'),                    -- Invalid Domain
(12,10,'2025-05-12',4200,''),                       -- Empty Status
(13,11,'2025-05-13',3800,NULL),                     -- NULL Status
(14,12,'2025-05-14',5100,'Pending'),                -- Wrong Case / Invalid Domain
(15,13,'2025-05-15',4600,'PAID');


