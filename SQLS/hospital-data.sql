-- rooms
INSERT INTO rooms (room_no, capacity, fee) VALUES
(101, 2, 100.00),
(102, 4, 150.00),
(103, 1, 00),
(104, 2, 80.0),
(105, 2, 100.00);

-- patients
INSERT INTO patients (patient_id, name, address, phone_number) VALUES
(1001, 'John Smith', '123 Main St, Anytown USA', '555-1234'),
(1002, 'Jane Doe', '456 Oak St, Anytown USA', '555-5678'),
(1003, 'Bob Johnson', '789 Elm St, Anytown USA', '555-9012'),
(1004, 'Samantha Lee', '321 Pine St, Anytown USA', '555-3456'),
(1005, 'David Kim', '654 Maple St, Anytown USA', '555-7890');

-- health_records
INSERT INTO health_records (record_id, patient_id, disease, date, status, description) VALUES
(1, 1001, 'Flu', '2023-01-01', 'Recovered', 'Prescribed rest and fluids'),
(2, 1002, 'Broken leg', '3-02-15', 'In treatment', 'Scheduled for surgery'),
(3, 1003, 'Pneumonia', '2023-03-10', 'Recovered', 'Prescribed antibiotics'),
(4, 1004, 'Migraine', '2023-04-01', 'In treatment', 'Prescribed painkillers'),
(5, 1005, 'Allergies', '2023-04-15', 'In treatment', 'Prescribed antihistamines');

-- hospitalized
INSERT INTO hospitalized (patient_id, room_no, chk_in_date, chk_out_date, no_of_nights) VALUES
(1001, 101, '2023-01-01', '2023-01-03', NULL),
(1002, 102, '2023-02-15', NULL, NULL),
(1003, 103, '2023-03-10', '2023-03-15', 5),
(1004, 104,  '2023-04-15', '2023-04-17', NULL),
(1005, 105,  '2023-04-15', '2023-04-19', 2);


-- staff
INSERT INTO staff (staff_id, name, address, phone, staff_type) VALUES
(2001, 'Dr. James Smith', '123 Main St, Anytown USA', '555-1234', 'physician'),
(2002, 'Nurse Jane Doe', '456 Oak St, Anytown USA', '555-5678', 'nurse'),
(2003, 'Dr. Sarah Johnson', '789 Elm St, Anytown USA', '555-9012', 'physician'),
(2004, 'Nurse Samantha Lee', '321 Pine St, Anytown USA', '555-3456', 'nurse'),
(2005, 'Dr. David Kim', '654 Maple', '555-7890', 'physician'),
(2006, 'Dr. Emily Chen', '789 Maple St, Anytown USA', '555-2468', 'physician'),
(2007, 'Nurse Tom Lee', '321 Oak St, Anytown USA', '555-3690', 'nurse'),
(2008, 'Dr. Rachel Kim', '654 Pine St, Anytown USA', '555-8024', 'physician'),
(2009, 'Nurse Sarah Johnson', '123 Elm St, Anytown USA', '555-9756', 'nurse'),
(2010, 'Dr. Michael Smith', '456 Main St, Anytown USA', '555-1357', 'physician');

-- physician
INSERT INTO physician (physician_id, certification_no, expertise, staff_id) VALUES
(3001, '12345', 'Cardiology', 2001),
(3002, '23456', 'Pediatrics', 2003),
(3003, '34567', 'Oncology', 2005),
(3006, '67890', 'Gastroenterology', 2006),
(3007, '78901', 'Endocrinology', 2008),
(3008, '89012', 'Rheumatology', 2010);

-- nurse
INSERT INTO nurse (nurse_id, certification_no, staff_id) VALUES
(4001, '98765', 2002),
(4002, '87654', 2004),
(4003, '76543', 2002),
(4006, '43210', 2007),
(4007, '32109', 2009);

-- medication
INSERT INTO medication (med_id, name, mfg_date, exp_date) VALUES
(5001, 'Aspirin', '2022-12-01', '2023-12-01'),
(5002, 'Ibuprofen', '2022-11-01', '2023-11-01'),
(5003, 'Acetaminophen', '2022-10-01', '2023-09-01'),
(5004, 'Lisinopril', '2022-08-01', '2023-08-01'),
(5005, 'Metformin', '2022-09-01', '2023-09-01');

-- provide_medication
INSERT INTO provide_medication (patient_id, med_id, daily_dose) VALUES
(1001, 5001, 2.0),
(1002, 5002, 1.0),
(1003, 5003, 0.5),
(1004, 5004, 1.5),
(1005, 5005, 1.0),
(1001, 5002, 1.5),
(1002, 5003, 1.0),
(1003, 5004, 2.0),
(1004, 5005, 1.5),
(1005, 5001, 2.0);

-- monitored
INSERT INTO monitored (patient_id, physician_id, duration) VALUES
(1001, 3001, 3),
(1002, 3002, 7),
(1003, 3003, 5),
(1001, 3006, 2),
(1002, 3007, 4),
(1003, 3008, 6);

-- instructions
INSERT INTO instructions (instruction_code, fee, description) VALUES
(6001, 50.00, 'Take one pill every 4 hours'),
(6002, 75.00, 'Apply cream to affected area twice daily'),
(6003, 100.00, 'Take two pills before bedtime'),
(6004, 125.00, 'Take one pill with food three times daily'),
(6005, 150.00, 'Take one pill every 12 hours');

-- orders
INSERT INTO orders (order_id, patient_id, physician_id, instruction_code, request_date) VALUES
(7001, 1001, 3001, 6001, '2023-01-01'),
(7002, 1002, 3002, 6002, '2023-02-15'),
(7003, 1003, 3003, 6003, '2023-03-10'),
(7006, 1001, 3006, 6002, '2023-01-15'),
(7007, 1002, 3007, 6003, '2023-02-28'),
(7008, 1003, 3008, 6004, '2023-03-20');

-- executions
INSERT INTO executions (execution_id, patient_id, nurse_id, instruction_code, execution_date, status) VALUES
(8001, 1001, 4001, 6001, '2023-01-01', 'Completed'),
(8002, 1002, 4002, 6002, '2023-02-15', 'In progress'),
(8003, 1003, 4003, 6003, '2023-03-10', 'Completed'),
(8006, 1001, 4006, 6002, '2023-01-15', 'Completed'),
(8007, 1002, 4007, 6003, '2023-02-28', 'Completed');

-- invoices
INSERT INTO invoice (invoice_id, room_no, patient_id, execution_id, amt) VALUES
(9001, 101, 1001, 8001, 50.00),
(9001, 101, 1001, 8006, NULL),
(9003, 103, 1003, 8003, NULL),
(9004, 102, 1002, 8002, NULL),
(9004, 102, 1002, 8007, NULL);

-- payments
INSERT INTO payments (pay_id, invoice_id, pay_date, due_amt, pay_amt) VALUES
(10001, 9001, '2023-01-03', NULL, NULL),
(10003, 9003, '2023-03-15', NULL, NULL),
(10004, 9004, '2023-04-10', NULL, NULL);