-- SQL QUERIES:

-- 1. Join Query: Retrieve the patient_id, name of the patient, their disease, and the physician who is monitoring them.
SELECT p.patient_id, p.name, h.disease, s.name AS physician_name
FROM patients p
JOIN health_records h ON p.patient_id = h.patient_id
JOIN monitored m ON p.patient_id = m.patient_id
JOIN physician ph ON m.physician_id = ph.physician_id
JOIN staff s ON ph.staff_id = s.staff_id;

-- 2. Aggregation Query: Retrieve the total number of patients who are currently hospitalized.
SELECT COUNT(*) AS total_hospitalized_patients
FROM hospitalized
WHERE chk_out_date IS NULL;

-- 3. Nested Query: Retrieve the name of the physician who has the highest number of patients under their care.
SELECT s.name AS physician_name
FROM staff s
WHERE s.staff_type = 'physician' AND s.staff_id = (
    SELECT p.staff_id
    FROM physician p
    JOIN monitored m on p.physician_id = m.physician_id 
    GROUP BY m.physician_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- 4. Join Query: Retrieve the patient_id, name of the patient, their medication, and the daily dose they are prescribed.
SELECT p.patient_id, p.name, m.name AS medication_name, pm.daily_dose
FROM patients p
JOIN provide_medication pm ON p.patient_id = pm.patient_id
JOIN medication m ON pm.med_id = m.med_id;

-- 5. Aggregation Query: Retrieve the total number of patients who have been prescribed painkillers.
SELECT COUNT(*) AS total_patients
FROM health_records
WHERE description LIKE '%painkillers%';

-- 6. Nested Query: Retrieve the names of physicians treating patients with pneumonia.
SELECT s.name AS physician_name
FROM staff s
WHERE s.staff_type = 'physician' AND s.staff_id IN (
    SELECT p.staff_id
    FROM physician p
    JOIN monitored m on p.physician_id = m.physician_id 
    JOIN health_records h ON m.patient_id = h.patient_id
    WHERE h.disease = 'Pneumonia'
    GROUP BY m.physician_id);

-- 7. Join Query: Retrieve the patient name, physician name, and duration for all monitored patients
SELECT p.name AS patient_name, s.name AS physician_name, m.duration
FROM patients p
JOIN monitored m ON p.patient_id = m.patient_id
JOIN physician ph ON m.physician_id = ph.physician_id
JOIN staff s on s.staff_id = ph.staff_id;

-- 8. Aggregation Query: Get total fees of each order.
SELECT o.order_id AS order_no, SUM(i.fee) as total_fee
FROM orders o
JOIN instructions i USING(instruction_code)
GROUP BY order_no;


-- 9. Nested Query: Retrieve the names of the nurses executing instructions for patients with pneumonia
SELECT s.name AS nurse_name
FROM staff s
JOIN nurse n on n.staff_id = s.staff_id
WHERE n.nurse_id IN (
    SELECT e.nurse_id
    FROM executions e
    JOIN health_records h on e.patient_id = h.patient_id
    WHERE h.disease = 'Pneumonia');

-- 10. Join Query: Retrieve the name, phone number and expertise of physicians who've monitored patient having Pneumonia
SELECT DISTINCT staff.name, staff.phone, physician.expertise
FROM staff
JOIN physician ON staff.staff_id = physician.staff_id
JOIN monitored ON physician.physician_id = monitored.physician_id
JOIN health_records ON monitored.patient_id = health_records.patient_id
WHERE health_records.disease = 'Pneumonia';

-- 11. Aggregation Query: The average number of nights a patient with Pneumonia stays in the hospital
SELECT AVG(no_of_nights) AS avg_length_of_stay
FROM hospitalized h
JOIN health_records hr USING(patient_id)
WHERE hr.disease = 'Pneumonia';

-- 12. Nested Query: Retrieve the names of the nurses who've treated patients with broken legs.
SELECT s.name AS nurse_name 
FROM staff s 
JOIN nurse n USING(staff_id)
WHERE n.nurse_id IN ( 
	SELECT e.nurse_id 
    FROM executions e 
    JOIN health_records h USING(patient_id) 
    WHERE h.disease = 'Broken leg'
);

-- 13. Aggregation Query: Retrieve patient names and the duration for which they were hospitalized
SELECT p.name, MAX(h.no_of_nights) as max_nights
FROM patients p
INNER JOIN hospitalized h ON p.patient_id = h.patient_id
GROUP BY p.name
HAVING max_nights > 0
ORDER BY max_nights DESC;

-- 14. Join Query: Retrieve name and address of patients who have stayed in room 101 in January 2023.
SELECT patients.name, patients.address, chk_in_date
FROM patients
JOIN hospitalized ON patients.patient_id = hospitalized.patient_id
WHERE hospitalized.room_no = 101
AND chk_in_date BETWEEN '2023-01-01' and '2023-02-01';

-- 15. Nested Query: Retrieve the names and addresses of patients who are medicated on Ibuprofen
SELECT patients.name, patients.address
FROM patients
WHERE patient_id IN (
	SELECT patient_id
    FROM provide_medication pm
    JOIN medication m USING(med_id)
    WHERE m.name = 'Ibuprofen'
);


-- VIEWS

-- 1. hospitalized_patients_view
CREATE VIEW hospitalized_patients_view AS
SELECT p.name, h.room_no, h.chk_in_date, h.chk_out_date, h.no_of_nights
FROM patients p
JOIN hospitalized h ON p.patient_id = h.patient_id
WHERE h.chk_out_date IS NULL;

-- 2. physician_patient_count_view
CREATE VIEW physician_patient_count_view AS
SELECT s.name AS physician_name, COUNT(*) AS patient_count
FROM staff s
JOIN physician ph ON s.staff_id = ph.staff_id
JOIN monitored m ON ph.physician_id = m.physician_id
GROUP BY s.name;

-- 3. medication_expiration_view
CREATE VIEW medication_expiration_view AS
SELECT m.name AS medication_name, m.mfg_date, m.exp_date, COUNT(*) AS total_patients
FROM medication m
JOIN provide_medication pm ON m.med_id = pm.med_id
GROUP BY m.name, m.mfg_date, m.exp_date;


-- Triggers:

-- 1. This trigger updates the due amount in the payments table when a new invoice is added.
DELIMITER //

CREATE TRIGGER update_payments_trigger
AFTER INSERT ON invoice
FOR EACH ROW
BEGIN
    INSERT INTO payments (invoice_id, pay_date, due_amt, pay_amt)
    VALUES (NEW.invoice_id, CURDATE(), (SELECT SUM(amt) FROM invoice WHERE invoice.invoice_id = NEW.invoice_id), 0);
END //
DELIMITER ;

-- 2. insert_health_records_trigger
DELIMITER //

CREATE TRIGGER insert_health_records_trigger
AFTER INSERT ON health_records
FOR EACH ROW
BEGIN
    IF NEW.disease = 'Appendicitis' THEN
        INSERT INTO instructions (instruction_code, fee, description)
        VALUES (4, 150.00, 'Prescribed surgery.');
    END IF;
END //

DELIMITER //

-- 3. No of Nights
DELIMITER //

CREATE TRIGGER update_no_of_nights_trigger
AFTER UPDATE ON hospitalized
FOR EACH ROW
BEGIN
    IF NEW.chk_out_date IS NOT NULL THEN
        UPDATE hospitalized
        SET no_of_nights = DATEDIFF(NEW.chk_out_date, chk_in_date)
        WHERE patient_id = NEW.patient_id AND room_no = NEW.room_no AND chk_in_date = NEW.chk_in_date;
    END IF;
END //

DELIMITER ;

-- 4. Update invoice payment
DELIMITER //

CREATE TRIGGER update_invoice_amt_trigger
AFTER INSERT ON executions
FOR EACH ROW
BEGIN
    UPDATE invoice
    SET amt = (SELECT fee FROM instructions WHERE instruction_code = NEW.instruction_code)
    WHERE patient_id = NEW.patient_id AND execution_id = NEW.execution_id;
END //

DELIMITER ;

-- Transactions:
-- 1. Register a new patient with their personal information, create an initial health record with 
--    a specific condition, assign a room for their hospitalization, and allocate a physician to monitor their health status.
START TRANSACTION;

SET @patient_id = 1090;
SET @record_id = 6;
SET @duration = 7;
SET @physician_id = 3002;
SET @room = 103;

-- Insert a new patient record
INSERT INTO patients (patient_id, name, address, phone_number)
VALUES (@patient_id, 'Robert Downey', '1234 Elm St', '555-1234');

-- Insert a new health record for the patient
INSERT INTO health_records (record_id, patient_id, disease, date, status, description)
VALUES (@record_id, @patient_id, 'Asthma', CURDATE(), 'Waiting for checkup.', 'URGENT');

-- Insert a new hospitalization record for the patient
INSERT INTO hospitalized (patient_id, room_no, chk_in_date, chk_out_date, no_of_nights)
VALUES (@patient_id, @room, CURDATE(), NULL, NULL);

-- Assign a physician to the patient
INSERT INTO monitored (patient_id, physician_id, duration)
VALUES (@patient_id, @physician_id, duration); -- Duration: 30 days

COMMIT;


-- 2.  Ensures that a medication record for Amoxicillin exists in the medication table and prescribes 
-- 	   it to specific patient with a defined daily dosage, creating a provide_medication record in the process
START TRANSACTION;

SET @patient_id = 1004;
SET @daily_dose = 3;
SET @medication_name = "Amoxicillin";

-- Insert a new medication record (if not already in the table)
INSERT INTO medication (med_id, name, mfg_date, exp_date)
VALUES (5006, @medication_name, '2022-01-01', '2023-12-31');

-- Get the medication id for 'Amoxicillin'
SELECT med_id INTO @medication_id
FROM medication
WHERE name = @medication_name;

-- Insert a new provide_medication record
INSERT INTO provide_medication (patient_id, med_id, daily_dose)
VALUES (@patient_id, @medication_id, @daily_dose);

COMMIT;
