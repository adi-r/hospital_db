/*
Create hospital database
*/
DROP DATABASE IF EXISTS hospital;
CREATE DATABASE hospital;
USE hospital;

CREATE TABLE IF NOT EXISTS rooms (
    room_no INT PRIMARY KEY,
    capacity INT NOT NULL,
    fee DECIMAL(10, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS patients (
    patient_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS health_records (
    record_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    disease VARCHAR(255) NOT NULL,
    date DATE NOT NULL,
    status VARCHAR(255) NOT NULL,
    description TEXT,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);



CREATE TABLE IF NOT EXISTS hospitalized (
    patient_id INT NOT NULL,
    room_no INT NOT NULL,
    chk_in_date DATE NOT NULL,
    chk_out_date DATE,
    PRIMARY KEY (patient_id, room_no),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (room_no) REFERENCES rooms(room_no)
);

ALTER TABLE hospitalized ADD COLUMN no_of_nights INT;
UPDATE hospitalized SET no_of_nights = DATEDIFF(end_date, start_date);

CREATE TABLE IF NOT EXISTS staff (
  staff_id INT PRIMARY KEY,
  name VARCHAR(255),
  address VARCHAR(255),
  phone VARCHAR(255),
  staff_type VARCHAR(10) CHECK (staff_type IN ('physician', 'nurse'))
);

CREATE TABLE IF NOT EXISTS physician (
  physician_id INT PRIMARY KEY,
  certification_no VARCHAR(255),
  expertise VARCHAR(255),
  staff_id INT,
  FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

CREATE TABLE nurse (
  nurse_id INT PRIMARY KEY,
  certification_no VARCHAR(255),
  staff_id INT,
  FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

CREATE TABLE medication (
    med_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    mfg_date DATE NOT NULL,
    exp_date DATE NOT NULL
);

CREATE TABLE provide_medication (
    patient_id INT NOT NULL,
    med_id INT NOT NULL,
    daily_dose DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (patient_id, med_id),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (med_id) REFERENCES medication(med_id)
);


CREATE TABLE instruction (
    instruction_code INT PRIMARY KEY,
    fee DECIMAL(10, 2) NOT NULL,
    description TEXT
);

CREATE TABLE Physician_Orders (
    patient_id INT NOT NULL,
    physician_id INT NOT NULL,
    instruction_code INT NOT NULL,
    order_date DATE NOT NULL,
    PRIMARY KEY (patient_id, physician_id, instruction_code),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (physician_id) REFERENCES Physicians(physician_id),
    FOREIGN KEY (instruction_code) REFERENCES Instructions(instruction_code)
);

CREATE TABLE Nurse_Orders (
    patient_id INT NOT NULL,
    physician_id INT NOT NULL,
    nurse_id INT NOT NULL,
    instruction_code INT NOT NULL,
    order_date DATE NOT NULL,
    execution_date DATE NOT NULL,
    status VARCHAR(255) NOT NULL,
    PRIMARY KEY (patient_id, physician_id, nurse_id, instruction_code),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (physician_id) REFERENCES Physicians(physician_id),
    FOREIGN KEY (nurse_id) REFERENCES Nurses(nurse_id),
    FOREIGN KEY (instruction_code) REFERENCES Instructions(instruction_code)
);



CREATE TABLE Cares (
    care_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    room_number INT NOT NULL,
    physician_id INT NOT NULL,
    nurse_id INT NOT NULL,
    instruction_code INT NOT
);




