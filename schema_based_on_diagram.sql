CREATE DATABASE clinic;

CREATE TABLE patients (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50),
    date_of_birth DATE
);

CREATE TABLE medical_histories (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    admitted_at TIMESTAMP,
    patient_id INTEGER,
    status VARCHAR(50),
    CONSTRAINT fk_patient FOREIGN KEY (patient_id) REFERENCES patients(id)
);

CREATE TABLE treatments (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    type VARCHAR(50),
    name VARCHAR(50)
);

CREATE TABLE medicalhistories_treatments (
    medical_history_id    INTEGER,
    treatment_id    INTEGER,
    CONSTRAINT fk_medical_history FOREIGN KEY (medical_history_id) REFERENCES medical_histories(id),
    CONSTRAINT fk_treatment FOREIGN KEY (treatment_id) REFERENCES treatments(id)
);

CREATE TABLE invoices (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    total_amount DECIMAL,
    generated_at TIMESTAMP,
    payed_at TIMESTAMP,
    medical_history_id INTEGER,
    CONSTRAINT fk_medical_history FOREIGN KEY (medical_history_id) REFERENCES medical_histories(id)
);

CREATE TABLE invoice_items (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    unit_price  DECIMAL,
    quantity    INTEGER,
    total_price DECIMAL,
    invoice_id  INTEGER,
    treatment_id    INTEGER,
    CONSTRAINT fk_invoice FOREIGN KEY (invoice_id) REFERENCES invoices(id),
    CONSTRAINT fk_treatment FOREIGN KEY (treatment_id) REFERENCES treatments(id)
);
