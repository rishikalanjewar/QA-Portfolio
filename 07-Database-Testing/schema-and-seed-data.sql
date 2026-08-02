BEGIN TRANSACTION;
CREATE TABLE dispensing_log (
    log_id        INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id      INTEGER NOT NULL,
    dispensed_by  INTEGER NOT NULL,
    dispensed_at  TEXT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (dispensed_by) REFERENCES users(user_id)
);
INSERT INTO "dispensing_log" VALUES(1,1,2,'2026-07-20 09:30:00');
INSERT INTO "dispensing_log" VALUES(2,2,3,'2026-07-20 10:00:00');
INSERT INTO "dispensing_log" VALUES(3,6,3,'2026-07-22 08:50:00');
INSERT INTO "dispensing_log" VALUES(4,7,2,'2026-07-22 09:20:00');
INSERT INTO "dispensing_log" VALUES(5,9,2,'2026-07-23 10:30:00');
INSERT INTO "dispensing_log" VALUES(6,10,3,'2026-07-23 11:05:00');
INSERT INTO "dispensing_log" VALUES(7,11,2,'2026-07-24 09:35:00');
INSERT INTO "dispensing_log" VALUES(8,12,3,'2026-07-24 10:40:00');
INSERT INTO "dispensing_log" VALUES(999,9999,2,'2026-07-24 12:00:00');
CREATE TABLE inventory (
    medication_id INTEGER PRIMARY KEY AUTOINCREMENT,
    medication    TEXT NOT NULL,
    batch_no      TEXT NOT NULL,
    stock_qty     INTEGER NOT NULL CHECK(stock_qty >= 0),
    expiry_date   TEXT NOT NULL,
    low_stock_threshold INTEGER NOT NULL DEFAULT 10
);
INSERT INTO "inventory" VALUES(1,'Paracetamol 500mg','B-1042',48,'2027-03-15',10);
INSERT INTO "inventory" VALUES(2,'Amoxicillin 250mg','B-2210',6,'2026-11-02',10);
INSERT INTO "inventory" VALUES(3,'Cetirizine 10mg','B-3305',10,'2027-06-20',10);
INSERT INTO "inventory" VALUES(4,'Metformin 500mg','B-4118',2,'2026-08-30',10);
INSERT INTO "inventory" VALUES(5,'Azithromycin 250mg','B-5027',15,'2025-12-01',10);
CREATE TABLE order_status_history (
    history_id    INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id      INTEGER NOT NULL,
    status        TEXT NOT NULL,
    changed_by    INTEGER NOT NULL,
    changed_at    TEXT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (changed_by) REFERENCES users(user_id)
);
INSERT INTO "order_status_history" VALUES(1,1,'Pending Verification',2,'2026-07-20 09:10:00');
INSERT INTO "order_status_history" VALUES(2,1,'Verified',1,'2026-07-20 09:20:00');
INSERT INTO "order_status_history" VALUES(3,1,'Dispensed',2,'2026-07-20 09:30:00');
INSERT INTO "order_status_history" VALUES(4,1,'Complete',2,'2026-07-20 09:33:00');
INSERT INTO "order_status_history" VALUES(5,2,'Pending Verification',3,'2026-07-20 09:40:00');
INSERT INTO "order_status_history" VALUES(6,2,'Verified',1,'2026-07-20 09:50:00');
INSERT INTO "order_status_history" VALUES(7,2,'Dispensed',3,'2026-07-20 10:00:00');
INSERT INTO "order_status_history" VALUES(8,2,'Complete',3,'2026-07-20 10:02:00');
INSERT INTO "order_status_history" VALUES(9,3,'Pending Verification',2,'2026-07-21 10:05:00');
INSERT INTO "order_status_history" VALUES(10,3,'Verified',1,'2026-07-21 10:15:00');
INSERT INTO "order_status_history" VALUES(11,4,'Pending Verification',3,'2026-07-21 11:15:00');
INSERT INTO "order_status_history" VALUES(12,5,'Pending Verification',2,'2026-07-21 12:00:00');
INSERT INTO "order_status_history" VALUES(13,5,'Rejected',1,'2026-07-21 12:10:00');
INSERT INTO "order_status_history" VALUES(14,6,'Pending Verification',3,'2026-07-22 08:30:00');
INSERT INTO "order_status_history" VALUES(15,6,'Verified',1,'2026-07-22 08:40:00');
INSERT INTO "order_status_history" VALUES(16,6,'Dispensed',3,'2026-07-22 08:50:00');
INSERT INTO "order_status_history" VALUES(17,6,'Complete',3,'2026-07-22 08:53:00');
INSERT INTO "order_status_history" VALUES(18,7,'Pending Verification',2,'2026-07-22 09:00:00');
INSERT INTO "order_status_history" VALUES(19,7,'Verified',1,'2026-07-22 09:10:00');
INSERT INTO "order_status_history" VALUES(20,7,'Dispensed',2,'2026-07-22 09:20:00');
INSERT INTO "order_status_history" VALUES(21,7,'Dispensing Error — Under Review',2,'2026-07-22 09:22:00');
INSERT INTO "order_status_history" VALUES(22,8,'Pending Verification',3,'2026-07-22 09:45:00');
INSERT INTO "order_status_history" VALUES(23,8,'Cancelled',3,'2026-07-22 09:50:00');
INSERT INTO "order_status_history" VALUES(24,9,'Pending Verification',2,'2026-07-23 10:10:00');
INSERT INTO "order_status_history" VALUES(25,9,'Verified',1,'2026-07-23 10:20:00');
INSERT INTO "order_status_history" VALUES(26,9,'Dispensed',2,'2026-07-23 10:30:00');
INSERT INTO "order_status_history" VALUES(27,9,'Complete',2,'2026-07-23 10:33:00');
INSERT INTO "order_status_history" VALUES(28,10,'Pending Verification',3,'2026-07-23 11:00:00');
INSERT INTO "order_status_history" VALUES(29,10,'Dispensed',3,'2026-07-23 11:05:00');
INSERT INTO "order_status_history" VALUES(30,10,'Complete',3,'2026-07-23 11:08:00');
INSERT INTO "order_status_history" VALUES(31,11,'Pending Verification',2,'2026-07-24 09:15:00');
INSERT INTO "order_status_history" VALUES(32,11,'Verified',1,'2026-07-24 09:25:00');
INSERT INTO "order_status_history" VALUES(33,11,'Dispensed',2,'2026-07-24 09:35:00');
INSERT INTO "order_status_history" VALUES(34,11,'Complete',2,'2026-07-24 09:38:00');
INSERT INTO "order_status_history" VALUES(35,12,'Pending Verification',3,'2026-07-24 10:20:00');
INSERT INTO "order_status_history" VALUES(36,12,'Verified',1,'2026-07-24 10:30:00');
INSERT INTO "order_status_history" VALUES(37,12,'Dispensed',3,'2026-07-24 10:40:00');
INSERT INTO "order_status_history" VALUES(38,12,'Complete',3,'2026-07-24 10:43:00');
CREATE TABLE orders (
    order_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    patient_name  TEXT NOT NULL,
    medication_id INTEGER NOT NULL,
    quantity      INTEGER NOT NULL CHECK(quantity > 0),
    status        TEXT NOT NULL CHECK(status IN (
                      'Pending Verification','Verified','Rejected',
                      'Dispensed','Dispensing Error — Under Review','Complete','Cancelled')),
    created_by    INTEGER NOT NULL,
    verified_by   INTEGER,
    created_at    TEXT NOT NULL,
    FOREIGN KEY (medication_id) REFERENCES inventory(medication_id),
    FOREIGN KEY (created_by) REFERENCES users(user_id),
    FOREIGN KEY (verified_by) REFERENCES users(user_id)
);
INSERT INTO "orders" VALUES(1,'Anita Sharma',1,2,'Complete',2,1,'2026-07-20 09:10:00');
INSERT INTO "orders" VALUES(2,'Ravi Mehta',2,1,'Complete',3,1,'2026-07-20 09:40:00');
INSERT INTO "orders" VALUES(3,'Neha Joshi',3,3,'Verified',2,1,'2026-07-21 10:05:00');
INSERT INTO "orders" VALUES(4,'Karan Patel',4,2,'Pending Verification',3,NULL,'2026-07-21 11:15:00');
INSERT INTO "orders" VALUES(5,'Sunita Rao',1,4,'Rejected',2,1,'2026-07-21 12:00:00');
INSERT INTO "orders" VALUES(6,'Amitabh Nair',5,2,'Complete',3,1,'2026-07-22 08:30:00');
INSERT INTO "orders" VALUES(7,'Priya Desai',2,1,'Dispensing Error — Under Review',2,1,'2026-07-22 09:00:00');
INSERT INTO "orders" VALUES(8,'Farhan Sheikh',1,1,'Cancelled',3,NULL,'2026-07-22 09:45:00');
INSERT INTO "orders" VALUES(9,'Meena Iyer',3,2,'Complete',2,1,'2026-07-23 10:10:00');
INSERT INTO "orders" VALUES(10,'Vikram Shah',1,3,'Complete',3,1,'2026-07-23 11:00:00');
INSERT INTO "orders" VALUES(11,'Alok Verma',4,1,'Complete',2,1,'2026-07-24 09:15:00');
INSERT INTO "orders" VALUES(12,'Divya Kapoor',2,1,'Complete',3,1,'2026-07-24 10:20:00');
CREATE TABLE users (
    user_id       INTEGER PRIMARY KEY AUTOINCREMENT,
    name          TEXT NOT NULL,
    role          TEXT NOT NULL CHECK(role IN ('Pharmacist','Technician','Admin')),
    is_active     INTEGER NOT NULL DEFAULT 1
);
INSERT INTO "users" VALUES(1,'Dr. Meera Iyer','Pharmacist',1);
INSERT INTO "users" VALUES(2,'Sanjay Rao','Technician',1);
INSERT INTO "users" VALUES(3,'Divya Nair','Technician',1);
INSERT INTO "users" VALUES(4,'Admin User','Admin',1);
CREATE TABLE vision_verification_log (
    verification_id  INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id          INTEGER NOT NULL,
    image_ref         TEXT NOT NULL,
    detected_medications TEXT,
    match_status      TEXT NOT NULL CHECK(match_status IN ('Verified','Rejected')),
    confidence_score  REAL NOT NULL,
    checked_at        TEXT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
INSERT INTO "vision_verification_log" VALUES(1,1,'img_ord1.jpg','Paracetamol 500mg','Verified',96.0,'2026-07-20 09:32:00');
INSERT INTO "vision_verification_log" VALUES(2,2,'img_ord2.jpg','Amoxicillin 250mg','Verified',91.5,'2026-07-20 10:01:30');
INSERT INTO "vision_verification_log" VALUES(3,6,'img_ord6.jpg','Azithromycin 250mg','Verified',88.0,'2026-07-22 08:52:00');
INSERT INTO "vision_verification_log" VALUES(4,7,'img_ord7.jpg','Cetirizine 10mg','Rejected',61.0,'2026-07-22 09:21:30');
INSERT INTO "vision_verification_log" VALUES(5,9,'img_ord9.jpg','Cetirizine 10mg','Verified',94.2,'2026-07-23 10:32:00');
INSERT INTO "vision_verification_log" VALUES(6,10,'img_ord10.jpg','Paracetamol 500mg','Verified',70.0,'2026-07-23 11:07:00');
INSERT INTO "vision_verification_log" VALUES(7,11,'img_ord11.jpg','Metformin 500mg','Verified',97.3,'2026-07-24 09:37:00');
INSERT INTO "vision_verification_log" VALUES(8,12,'img_ord12.jpg','Amoxicillin 250mg','Verified',89.9,'2026-07-24 10:42:00');
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_medication ON orders(medication_id);
CREATE INDEX idx_vision_order ON vision_verification_log(order_id);
DELETE FROM "sqlite_sequence";
INSERT INTO "sqlite_sequence" VALUES('users',4);
INSERT INTO "sqlite_sequence" VALUES('inventory',5);
INSERT INTO "sqlite_sequence" VALUES('orders',12);
INSERT INTO "sqlite_sequence" VALUES('order_status_history',38);
INSERT INTO "sqlite_sequence" VALUES('dispensing_log',999);
INSERT INTO "sqlite_sequence" VALUES('vision_verification_log',8);
COMMIT;
