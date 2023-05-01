-- SQL QUERIES:

-- 1. Join Query: Retrieve the name of the patient, their disease, and the physician who is monitoring them.
SELECT p.name, h.disease, s.name AS physician_name
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

-- 4. Join Query: Retrieve the name of the patient, their medication, and the daily dose they are prescribed.
SELECT p.name, m.name AS medication_name, pm.daily_dose
FROM patients p
JOIN provide_medication pm ON p.patient_id = pm.patient_id
JOIN medication m ON pm.med_id = m.med_id;

-- 5. Aggregation Query: Retrieve the total number of patients who have been prescribed painkillers.
SELECT COUNT(*) AS total_patients
FROM health_records
WHERE description LIKE '%painkillers%';

-- 6. Nested Query: Retrieve the name of the physician who has the highest number of patients with pneumonia.
SELECT s.name AS physician_name
FROM staff s
WHERE s.staff_type = 'physician' AND s.staff_id = (
    SELECT p.staff_id
    FROM physician p
    JOIN monitored m on p.physician_id = m.physician_id 
    JOIN health_records h ON m.patient_id = h.patient_id
    WHERE h.disease = 'Pneumonia'
    GROUP BY m.physician_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- 7. Join Query: Retrieve the name of the patient, their medication, and the expiration date of the medication.
-- SELECT p.name, m.name AS medication_name, m.exp_date
-- FROM patients p
-- JOIN provide_medication pm ON p.patient_id = pm.patient_id
-- JOIN medication m ON pm.med_id = m.med_id;

-- 8. Aggregation Query: Retrieve the total number of patients who have been prescribed antibiotics and are still in treatment.
SELECT COUNT(*) AS total_patients
FROM health_records
WHERE disease = 'Broken leg' AND status = 'In treatment';

-- 9. Nested Query: Retrieve the name of the physician who has the highest number of patients with appendicitis.
SELECT s.name AS physician_name
FROM staff s
WHERE s.staff_type = 'physician' AND s.staff_id = (
    SELECT p.staff_id
    FROM physician p
    JOIN monitored m on p.physician_id = m.physician_id 
    JOIN health_records h ON m.patient_id = h.patient_id
    WHERE h.disease = 'Appendicitis'
    GROUP BY m.physician_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- 10. Join Query: Retrieve the name of the patient, their medication, and the manufacturing date of the medication.
SELECT p.name, m.name AS medication_name, m.mfg_date
FROM patients p
JOIN provide_medication pm ON p.patient_id = pm.patient_id
JOIN medication m ON pm.med_id = m.med_id;

-- 11. Aggregation Query: Retrieve the total number of patients who have been prescribed surgery.
SELECT COUNT(*) AS total_patients
FROM health_records
WHERE description LIKE '%surgery%';

-- 12. Nested Query: Retrieve the name of the physician who has the highest number of patients with broken legs.
SELECT s.name AS physician_name
FROM staff s
WHERE s.staff_type = 'physician' AND s.staff_id = (
    SELECT p.staff_id
    FROM physician p
    JOIN monitored m on p.physician_id = m.physician_id 
    JOIN health_records h ON m.patient_id = h.patient_id
    WHERE h.disease = 'Broken leg'
    GROUP BY m.physician_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- 13. Join Query: Retrieve the name of the patient, their medication, and the fee for the medication.
-- SELECT p.name, m.name AS medication_name, i.fee
-- FROM patients p
-- JOIN provide_medication pm ON p.patient_id = pm.patient_id
-- JOIN medication m ON pm.med_id = m.med_id
-- JOIN instructions i ON m.name = i.description;

-- 14. Aggregation Query: Retrieve the total number of patients who have been prescribed physical therapy.
SELECT COUNT(*) AS total_patients
FROM health_records
WHERE description LIKE '%physical therapy%';

-- 15. Nested Query: Retrieve the name of the physician who has the highest number of patients with the flu.
SELECT s.name AS physician_name
FROM staff s
WHERE s.staff_type = 'physician' AND s.staff_id = (
    SELECT p.staff_id
    FROM physician p
    JOIN monitored m on p.physician_id = m.physician_id 
    JOIN health_records h ON m.patient_id = h.patient_id
    WHERE h.disease = 'Flu'
    GROUP BY m.physician_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
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

