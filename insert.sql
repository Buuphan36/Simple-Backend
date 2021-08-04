INSERT INTO region (region_name,region_description) VALUES ('na','north_america');
INSERT INTO region (region_name,region_description) VALUES ('eu','europe');
INSERT INTO region (region_name,region_description) VALUES ('as','asia');

INSERT INTO account_type (description) VALUES ('general_account');
INSERT INTO account_type (description) VALUES ('veteran_account');
INSERT INTO account_type (description) VALUES ('family_account');

INSERT INTO user (user_firstname, user_lastname, user_email) VALUES ('admin','who','admin@mail.edu');
INSERT INTO user (user_firstname, user_lastname, user_email) VALUES ('anthony','susan','sanathy@mail.edu');
INSERT INTO user (user_firstname, user_lastname, user_email) VALUES ('alice','lee','leece@mail.edu');

INSERT INTO session (user, session_time) VALUES (1,'2020-04-08 00:00:00');
INSERT INTO session (user, session_time) VALUES (2,'2020-04-08 00:00:00');
INSERT INTO session (user, session_time) VALUES (3,'2020-04-08 00:00:00');

INSERT INTO healthcare_plan (healthcare_plan_cost, description) VALUES (100,'general_plan');
INSERT INTO healthcare_plan (healthcare_plan_cost, description) VALUES (200,'veteran_plan');
INSERT INTO healthcare_plan (healthcare_plan_cost, description) VALUES (300,'family _plan');

INSERT INTO available_plans (account_type, plan) VALUES (1,1);
INSERT INTO available_plans (account_type, plan) VALUES (2,2);
INSERT INTO available_plans (account_type, plan) VALUES (3,3);

INSERT INTO payment_type (address, city, zipcode, state) VALUES ('98 jose', 'san_jose', 95110, 'ca');
INSERT INTO payment_type (address, city, zipcode, state) VALUES ('10 fran', 'san_francisco',94112, 'ca');
INSERT INTO payment_type (address, city, zipcode, state) VALUES ('123 york', 'new_york', 11215, 'ny');

INSERT INTO bank_account (payment_type, bank, routing, acc_number) VALUES (1,'well_fargo',1234,1111);
INSERT INTO bank_account (payment_type, bank, routing, acc_number) VALUES (2,'bank_of_america',1235,1112);
INSERT INTO bank_account (payment_type, bank, routing, acc_number) VALUES (3,'citigroup', 1236, 1113);

INSERT INTO billing_info (user, payment_type, amount) VALUES (1,1,100);
INSERT INTO billing_info (user, payment_type, amount) VALUES (2,2,200);
INSERT INTO billing_info (user, payment_type, amount) VALUES (3,3,300);

INSERT INTO credit_card (payment_type, card_number, bank_name, exp_date, cvv) VALUES (1,111111,'well_fargo','2008-01-11',544);
INSERT INTO credit_card (payment_type, card_number, bank_name, exp_date, cvv) VALUES (2,111112,'bank_of_america','2008-11-11',545);
INSERT INTO credit_card (payment_type, card_number, bank_name, exp_date, cvv) VALUES (3,111113,'bank_of_america','2009-07-11',546);

INSERT INTO debit_card (payment_type, card_number, bank_name, exp_date, cvv) VALUES (1,222222,'well_fargo','2008-08-12',609);
INSERT INTO debit_card (payment_type, card_number, bank_name, exp_date, cvv) VALUES (2,222223,'well_fargo','2009-10-03',790);
INSERT INTO debit_card (payment_type, card_number, bank_name, exp_date, cvv) VALUES (3,222223,'well_fargo','2019-12-12',549);

INSERT INTO medical_field (field_name) VALUES ('dentist');
INSERT INTO medical_field (field_name) VALUES ('pharmacist');
INSERT INTO medical_field (field_name) VALUES ('optometrist');

INSERT INTO doctor (doctor_name, doctor_specialty) VALUES ('dr.lee',1);
INSERT INTO doctor (doctor_name, doctor_specialty) VALUES ('dr.ortiz',2);
INSERT INTO doctor (doctor_name, doctor_specialty) VALUES ('dr.doe',3);

INSERT INTO medical_exam (patient,examiner, schedule) VALUES (1,1,'12/15/2020');
INSERT INTO medical_exam (patient,examiner, schedule) VALUES (2,2,'12/15/2020');
INSERT INTO medical_exam (patient,examiner, schedule) VALUES (3,3,'12/15/2020');

INSERT INTO medical_service (medical_service_name) VALUES ('surgery');
INSERT INTO medical_service (medical_service_name) VALUES ('therapy');
INSERT INTO medical_service (medical_service_name) VALUES ('rehabilitation');

INSERT INTO available_medical_service (user_id, service_id) VALUES (1,1);
INSERT INTO available_medical_service (user_id, service_id) VALUES (2,2);
INSERT INTO available_medical_service (user_id, service_id) VALUES (3,3);