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
    no_of_nights INT,
    PRIMARY KEY (patient_id, room_no, chk_in_date),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (room_no) REFERENCES rooms(room_no)
);

-- ALTER TABLE hospitalized ADD COLUMN no_of_nights INT;
-- UPDATE hospitalized SET no_of_nights = DATEDIFF(end_date, start_date);

CREATE TABLE IF NOT EXISTS staff (
  staff_id INT PRIMARY KEY,
  name VARCHAR(255),
  address VARCHAR(255),
  phone VARCHAR(255),
  staff_type ENUM('physician', 'nurse')
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

CREATE TABLE IF NOT EXISTS monitored (
	patient_id INT NOT NULL,
    physician_id INT NOT NULL,
    duration INT NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (physician_id) REFERENCES physician(physician_id),
    PRIMARY KEY (patient_id, physician_id)
);

CREATE TABLE IF NOT EXISTS instructions (
    instruction_code INT PRIMARY KEY,
    fee DECIMAL(10, 2) NOT NULL,
    description TEXT
);



CREATE TABLE IF NOT EXISTS orders (
	order_id INT ,
    patient_id INT NOT NULL,
    physician_id INT NOT NULL,
    instruction_code INT NOT NULL,
    request_date DATE NOT NULL,
PRIMARY KEY(order_id, instruction_code),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (physician_id) REFERENCES physician(physician_id),
    FOREIGN KEY (instruction_code) REFERENCES instructions(instruction_code)
);

CREATE TABLE IF NOT EXISTS executions (
	execution_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    nurse_id INT NOT NULL,
    instruction_code INT NOT NULL,
    execution_date DATE NOT NULL,
    status VARCHAR(255) NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (nurse_id) REFERENCES nurse(nurse_id),
    FOREIGN KEY (instruction_code) REFERENCES instructions(instruction_code)
);

CREATE TABLE IF NOT EXISTS invoice (
	invoice_id INT NOT NULL,
    room_no INT NOT NULL,
    patient_id INT NOT NULL,
    execution_id INT NOT NULL,
    amt DECIMAL(10,2),
    PRIMARY KEY(invoice_id, execution_id),
	FOREIGN KEY (room_no) REFERENCES rooms(room_no),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (execution_id) REFERENCES executions(execution_id)
);

CREATE TABLE IF NOT EXISTS payments (
	pay_id INT PRIMARY KEY,
    invoice_id INT NOT NULL,
    pay_date DATE NOT NULL,
    due_amt DECIMAL(10,2),
    pay_amt DECIMAL(10,2),
    FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id)
);
