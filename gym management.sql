/* creations des tables */
CREATE TABLE members (
    m_id numeric PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    address VARCHAR(100),
    telephone VARCHAR(15),
    email VARCHAR(50),
    membership_type VARCHAR(50),
    date_deb DATE,
    date_fin DATE
);
CREATE TABLE entraineurs (
    t_id INT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    telephone VARCHAR(15),
    email VARCHAR(50),
    qualifications VARCHAR(100)
);

CREATE TABLE plans (
    p_id INT PRIMARY KEY,
	p_nom VARCHAR(50) NOT NULL,
    duration INT,
    prix DECIMAL(10,2)
);

CREATE TABLE sessions (
    s_id INT PRIMARY KEY,
    s_nom VARCHAR(50) NOT NULL,
    s_date DATE,
    s_temp TIME,
    location VARCHAR(100),
    t_id INT,
    FOREIGN KEY (t_id) REFERENCES entraineurs(t_id)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    m_id INT,
    payment_amount DECIMAL(10,2),
    payment_date DATE,
    FOREIGN KEY (m_id) REFERENCES members(m_id)
);



/* creation de user*/
CREATE USER gym_admin IDENTIFIED BY 'gym_admin';
GRANT SELECT, INSERT, UPDATE, DELETE ON gym.* TO gym_admin;

/* creation de role*/
CREATE ROLE gym_trainer;

/*d’attribution des privilèges aux utilisateurs*/
GRANT SELECT, INSERT, UPDATE ON gym.members TO gym_trainer;
GRANT SELECT, INSERT, UPDATE ON gym.sessions TO gym_trainer;
GRANT gym_trainer TO gym_admin;

/* insertion des données */
INSERT INTO members (m_id, nom, address, telephone, email, membership_type, date_deb, date_fin)
VALUES (1, 'ahmed', '123 rue el oudoul', '123456789', 'ahmed@email.com', 'Gold', '2023-01-01', '2023-12-31','m'),
(2, 'mohamed', '456 centre', '123456789', 'mohamed@email.com', 'Silver', '2023-02-01', '2023-07-31','m'),
(3, 'roua', '69 rue haj ahmed', '123456789', 'roua@email.com', 'Gold', '2023-01-01', '2023-12-31','f');
INSERT INTO entraineurs (t_id, nom, telephone, email, qualifications)
VALUES (1, 'ghaith', '25487695', 'ghaith@email.com', 'ACE Certified Personal Trainer'),
(2, 'Sara', '555897466', 'sara@email.com', 'NASM Certified Personal Trainer');
INSERT INTO entraineurs (t_id, nom, telephone, email, qualifications)
values (3,'raed','548725563','raed@gmail.com','ACE Certified Personal Trainer');
INSERT INTO plans (p_id, p_nom, duration, prix)
VALUES (1, 'Plan A', 12, 1000.00),
(2, 'Plan B', 6, 600.00),
(3,'Plan c',1,100.00);
INSERT INTO sessions (s_id, s_nom, s_date, s_temp, location, t_id)
VALUES (1, 'box', '2023-04-25', '18:00:00', 'Studio 1', 1),
(2, 'yoga', '2023-04-26', '19:00:00', 'Studio 2', 2),
(3, 'bodybuilding', '2023-04-26', '20:00:00', 'Studio 3', 3);
INSERT INTO payments (payment_id, m_id, payment_amount, payment_date)
VALUES (1, 1, 1000.00, '2023-04-01'),
(2, 2, 600.00, '2023-04-01'),
(3,3,100.00,'2023-04-01');

/* creation des vues */
CREATE VIEW member_contact_info AS
SELECT nom,telephone
FROM members;
CREATE VIEW trainer_info AS
SELECT nom, qualifications
FROM entraineurs;
CREATE VIEW monthly_revenue AS
SELECT SUM(payment_amount) AS total_revenue
FROM payments
WHERE MONTH(payment_date) = MONTH(CURRENT_DATE()) AND YEAR(payment_date) = YEAR(CURRENT_DATE());
CREATE VIEW expiring_memberships AS
SELECT nom, membership_type,date_deb
FROM members
WHERE DATEDIFF(date_fin, CURRENT_DATE()) <= 30;

/*Trois requêtes de mise à jour des tables*/
ALTER TABLE members
ADD COLUMN gender VARCHAR(10);
ALTER TABLE members
ADD CONSTRAINT unique_email UNIQUE (email);
ALTER TABLE sessions
MODIFY COLUMN location VARCHAR(150);

/*Trois requêtes de mise à jour des données dans les tables*/
UPDATE plans
SET prix = 99.99
WHERE p_id = 3;
UPDATE members
SET address = 'rue el basatin'
WHERE m_id = 2;
UPDATE entraineurs
SET telephone = 525148657
WHERE t_id = 2;

/* Trois requêtes de sélection simple */
SELECT * FROM entraineurs WHERE qualifications LIKE '%ACE%';
SELECT * FROM members WHERE membership_type='Gold';
SELECT * FROM plans;

/* Trois requêtes de ORDER BY, GROUP BY, HAVING */
SELECT * FROM members
ORDER BY date_deb DESC;
SELECT membership_type, COUNT(*) AS total_memberships
FROM members
GROUP BY membership_type;
SELECT membership_type, COUNT(*) AS nb_members
FROM members
GROUP BY membership_type
HAVING COUNT(*) >= 1;

/* requestes des jointures */

-- récupérer le nombre de sessions dispensées par chaque entraîneur 
SELECT e.nom, COUNT(*) AS nb_sessions
FROM sessions s
INNER JOIN entraineurs e ON s.t_id = e.t_id
GROUP BY e.nom;
-- les noms des membres ,nom et date des sessions au cours de l'annee 2023.
SELECT members.nom, sessions.s_nom, sessions.s_date
FROM members
JOIN sessions ON members.m_id = sessions.s_id
WHERE sessions.s_date BETWEEN '2023-01-01' AND '2023-12-31';
-- nombre des session pour chaque plan
SELECT p.p_nom, COUNT(s.s_id) AS session_count
FROM plans p
LEFT JOIN sessions s ON p.p_id = s.s_id
GROUP BY p.p_id
HAVING COUNT(s.s_id) < 5;
-- les noms des members avec leur payment
SELECT m.nom, p.payment_amount
FROM members m
RIGHT JOIN payments p ON m.m_id = p.m_id;

/* creation des index */
CREATE INDEX member_email ON members(email);
CREATE INDEX session_date ON sessions(s_date);
CREATE INDEX plans_duration ON plans (duration);
CREATE INDEX trainers_qualifications ON entraineurs (qualifications);

/* creation des sequences 
 The simplest way for creating a sequence in MySQL 
is by defining the column as AUTO_INCREMENT during table creation */

ALTER TABLE plans modify p_id int AUTO_INCREMENT ;
ALTER TABLE payments modify payment_id int AUTO_INCREMENT ; 
ALTER TABLE sessions modify s_id int AUTO_INCREMENT ;
ALTER TABLE members modify m_id int AUTO_INCREMENT ;


















