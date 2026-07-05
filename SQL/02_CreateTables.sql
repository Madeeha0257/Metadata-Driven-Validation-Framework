USE HospitalManagementDB;
GO


-- Department

CREATE TABLE hospital.Department
(
    Department_ID INT,
    Department_Name VARCHAR(100),
    Location VARCHAR(100)
);
GO


-- Doctor

CREATE TABLE hospital.Doctor
(
    Doctor_ID INT,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Gender VARCHAR(20),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    Experience_Years INT,
    Department_ID INT
);
GO


-- Patient

CREATE TABLE hospital.Patient
(
    Patient_ID INT,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Gender VARCHAR(20),
    DOB DATE,
    Email VARCHAR(100),
    Phone VARCHAR(20),
    Blood_Group VARCHAR(10),
    Address VARCHAR(200)
);
GO


-- Appointment

CREATE TABLE hospital.Appointment
(
    Appointment_ID INT,
    Patient_ID INT,
    Doctor_ID INT,
    Appointment_Date DATE,
    Appointment_Time TIME,
    Status VARCHAR(30)
);
GO


-- Admission

CREATE TABLE hospital.Admission
(
    Admission_ID INT,
    Patient_ID INT,
    Doctor_ID INT,
    Room_Number VARCHAR(20),
    Admission_Date DATE,
    Discharge_Date DATE
);
GO


-- Bill

CREATE TABLE hospital.Bill
(
    Bill_ID INT,
    Patient_ID INT,
    Bill_Date DATE,
    Total_Amount DECIMAL(10,2),
    Payment_Status VARCHAR(30)
);
GO