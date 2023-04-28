/*
Insert data into rooms
*/
INSERT INTO rooms (room_no, capacity, fee) VALUES
(101, 2, 50),
(102, 1, 30),
(103, 4, 100),
(104, 2, 60),
(105, 3, 80);

/*
Insert data into patients
*/
INSERT INTO patients (patient_ID, name, address, phone_number) VALUES
(1, 'John Smith', '123 Main St', '555-1234'),
(2, 'Jane Doe', '456 Elm St', '555-5678'),
(3, 'Bob Johnson', '789 Oak St', '555-9012'),
(4, 'Samantha Lee', '234 Maple St', '555-3456'),
(5, 'Mike Davis', '567 Pine St', '555-7890');

/*
Insert data into health_records
*/
INSERT INTO health_records (record_id, patient_id, disease, date, status, description) VALUES
(1, 1, 'Flu', '2023-01-15', 'Recovered', 'Prescribed rest and fluids.'),
(2, 2, 'Broken Arm', '2023-02-10', 'Healing', 'Cast applied.'),
(3, 3, 'Pneumonia', '2023-03-05', 'Recovering', 'Antibiotics prescribed.'),
(4, 4, 'Heart Attack', '2023-04-01', 'Stable', 'Under observation.'),
(5, 5, 'Appendicitis', '2023-05-01', 'Recovered', 'Surgery performed.');

/*
Insert data into hospitalized
*/
INSERT INTO hospitalized (patient_id, room_no, chk_in_date, chk_out_date, no_of_nights) VALUES
(1, 101, 2023-04-01),
(2, 101, 2023-04-05),
(3, 102, 2023-01-01),
(3, 104, 2023-03-04),
(4, 105, 2023-04-16);

/*
Insert data into staff
*/
INSERT INTO staff (staff_id, name, address, phone, staff_type) VALUES
(1, 'James Smith', '111 Main St', '555-1111', 'physician'),
(2, 'Lisa Brown', '222 Elm St', '555-2222', 'physician'),
(3, 'Michael Lee', '333 Oak St', '555-3333', 'physician'),
(4, 'Sarah Davis', '444 Maple St', '555-4444', 'physician'),
(5, 'Jane Doe', '555 Pine St', '555-5555', 'physician'),
(6, 'James Doe', '555 Pine St', '555-6666', 'nurse'),
(7, 'Lewis Hamilton', '666 Nemo St', '555-7777', 'nurse'),
(8, 'Max Verstappen', '777 Triton St', '555-8888', 'nurse'),
(9, 'Harvey Specter' '888  Neptune St', '555-9999', 'nurse'),
(10, 'Sara Riazi', '999 Poseidon St', '666-1111', 'nurse');

/*
Insert data into physicians
*/
INSERT INTO physicians (physician_id, certification_no, expertise, staff_id) VALUES
(1, '123456', 'Cardiology', 1),
(2, '234567', 'Pediatrics', 2),
(3, '345678', 'Neurology', 3),
(4, '456789', 'Oncology', 4),
(5, '567890', 'Orthopedics', 5);

/*
Insert data into nurse
*/
INSERT INTO nurse (nurse_id, certification_no, staff_id) VALUES
(1, '654321', 6),
(2, '765432', 7),
(3, '876543', 8),
(4, '098765', 9),
(5, '789012', 10);

/*
Insert data into medication
*/
INSERT INTO medication (med_id, name, mfg_date, exp_date) VALUES
(1, 'Paracetamol', 2023-01-10, 2025-05-03),
(2, 'Azithromycin', '2023-01-01', '2024-03-03'),
(3, 'Aspirin', '2023-01-01', '2025-02-21'),
(4, 'Loperamide', '2023-01-01', '2024-08-09'),
(5, 'ORS', '2023-02-01', '2025-01-01');

/*
Insrt data into provide_medication
*/






