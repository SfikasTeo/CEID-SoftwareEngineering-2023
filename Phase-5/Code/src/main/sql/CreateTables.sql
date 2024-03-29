-- @block dbcreate
CREATE DATABASE LIVE_THE_CITY_SEPR2023;

-- @block dbuse
USE LIVE_THE_CITY_SEPR2023;

-- @block Users
CREATE OR REPLACE TABLE User(
id INT NOT NULL AUTO_INCREMENT,
username VARCHAR(30) NOT NULL,
upass VARCHAR(50) NOT NULL,
email VARCHAR(50) NOT NULL,
PRIMARY KEY (id)
);

CREATE OR REPLACE TABLE SimpleUser(
suid INT NOT NULL,
score INT DEFAULT 0,
PRIMARY KEY (suid),
CONSTRAINT fk_simpleuser_user FOREIGN KEY (suid) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE OR REPLACE TABLE TourGuide(
tgid INT NOT NULL,
iban VARCHAR(27) NOT NULL,
PRIMARY KEY(tgid),
CONSTRAINT fk_tourguide_user FOREIGN KEY (tgid) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE OR REPLACE TABLE Host(
hid INT NOT NULL,
iban VARCHAR(27) NOT NULL,
hname VARCHAR(100) NOT NULL,
haddress VARCHAR(100) NOT NULL,
PRIMARY KEY(hid),
CONSTRAINT fk_host_user FOREIGN KEY (hid) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE
);

--@block Tours
CREATE OR REPLACE TABLE Tour(
id INT NOT NULL AUTO_INCREMENT,
title VARCHAR(100) NOT NULL,
virtual BOOLEAN DEFAULT(false),
descr VARCHAR(400),
duration TINYINT,
startlocation VARCHAR(40) NOT NULL,
groups_per_date TINYINT DEFAULT 3,
spots_per_group TINYINT DEFAULT 12,
public BOOLEAN DEFAULT 0,
datepublished DATETIME DEFAULT NULL,
price FLOAT(2,2) NOT NULL,
rating FLOAT(1,1) DEFAULT 0,
times_bought SMALLINT UNSIGNED DEFAULT 0,
offered_by INT NOT NULL,
PRIMARY KEY (id),
UNIQUE (title),
CONSTRAINT fk_tour_guide FOREIGN KEY (offered_by) REFERENCES TourGuide(tgid) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE OR REPLACE TABLE Dates4Tour(
id INT NOT NULL AUTO_INCREMENT,
tourid INT NOT NULL,
datetime4tour DATETIME NOT NULL,
PRIMARY KEY (id),
CONSTRAINT fk_dates4tour_tour FOREIGN KEY (tourid) REFERENCES Tour(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE OR REPLACE TABLE VirtualTour(
vtid INT NOT NULL,
vtpath VARCHAR(250),
PRIMARY KEY (vtid),
CONSTRAINT fk_virtualtour_tour FOREIGN KEY (vtid) REFERENCES Tour(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- @block Event
CREATE OR REPLACE TABLE Event(
id INT NOT NULL AUTO_INCREMENT,
title VARCHAR(200),
planner INT NOT NULL,
descr VARCHAR(400),
event_date DATETIME NOT NULL,
event_location VARCHAR(200) NOT NULL,
date_uploaded DATETIME DEFAULT NOW(),
rating FLOAT(1,1) DEFAULT 0,
attends SMALLINT DEFAULT 0,
PRIMARY KEY (id),
CONSTRAINT fk_event_guide FOREIGN KEY (planner) REFERENCES TourGuide(tgid) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_event_host FOREIGN KEY (planner) REFERENCES Host(hid) ON DELETE CASCADE ON UPDATE CASCADE
);

-- @block Participation
CREATE OR REPLACE TABLE Participation(
id INT NOT NULL AUTO_INCREMENT,
partype enum('Tour', 'Event'),
participant INT NOT NULL,
PRIMARY KEY (id),
CONSTRAINT fk_participation_simpleuser FOREIGN KEY (participant) REFERENCES SimpleUser(suid) 
ON DELETE CASCADE ON UPDATE CASCADE
);

-- @block Quiz
CREATE OR REPLACE TABLE Quiz(
qid INT NOT NULL AUTO_INCREMENT,
title VARCHAR(100) NOT NULL,
on_tour INT NOT NULL,
descr VARCHAR(200),
succes_point TINYINT(2),
qpath VARCHAR(250),
date_uploaded DATETIME DEFAULT NOW(),
PRIMARY KEY (qid),
CONSTRAINT fk_quiz_tour FOREIGN KEY (on_tour) REFERENCES Tour(id) ON DELETE CASCADE ON UPDATE CASCADE 
);

CREATE OR REPLACE TABLE QuizQuestion(
id INT NOT NULL AUTO_INCREMENT,
qtext VARCHAR(500),
answer VARCHAR(50),
on_quiz INT NOT NULL,
qpath VARCHAR(250),
PRIMARY KEY (id),
CONSTRAINT fk_question_quiz FOREIGN KEY (on_quiz) REFERENCES Quiz(qid) ON DELETE CASCADE ON UPDATE CASCADE 
);

-- @block Tags
CREATE OR REPLACE TABLE Tags(
id INT NOT NULL AUTO_INCREMENT,
tagname VARCHAR(50),
PRIMARY KEY (id)
);

CREATE OR REPLACE TABLE TEtags(
id INT NOT NULL AUTO_INCREMENT,
tagid INT NOT NULL,
on_object enum('Tour', 'Event'),
objectid INT NOT NULL,
PRIMARY KEY (id), 
CONSTRAINT fk_TEtags_tag FOREIGN KEY (tagid) REFERENCES Tags(id) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_TEtags_tour FOREIGN KEY (objectid) REFERENCES Tour(id) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_TEtags_event FOREIGN KEY (objectid) REFERENCES Event(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- @block Payment
CREATE OR REPLACE TABLE Payment(
id INT NOT NULL AUTO_INCREMENT,
suid INT NOT NULL,
product_id INT,
amount FLOAT(2,2) NOT NULL,
payment_date DATETIME DEFAULT NOW(),
receipt_path VARCHAR(250) NOT NULL,
certificate_no INT,
certificate_path VARCHAR(250) NOT NULL,
PRIMARY KEY (id),
UNIQUE (certificate_no),
CONSTRAINT fk_payment_simuser FOREIGN KEY (suid) REFERENCES SimpleUser(suid) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_payment_tour FOREIGN KEY (product_id) REFERENCES Tour(id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- @block Jobs
CREATE OR REPLACE TABLE JobOffer(
id INT NOT NULL AUTO_INCREMENT,
date_opened DATETIME DEFAULT NOW(),
expires DATETIME,
title VARCHAR(40) NOT NULL,
descr VARCHAR(500),
num_employess TINYINT DEFAULT 1,
salary FLOAT(4,2) NOT NULL,
files_path VARCHAR(250) NOT NULL,
public BOOLEAN DEFAULT 0,
PRIMARY KEY (id)
);

CREATE OR REPLACE TABLE JOtags(
id INT NOT NULL AUTO_INCREMENT,
joid INT NOT NULL,
tid INT NOT NULL,
PRIMARY KEY (id),
CONSTRAINT fk_JOtags_JobOffer FOREIGN KEY (joid) REFERENCES JobOffer(id) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_JOtags_Tags FOREIGN KEY (tid) REFERENCES Tags(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE OR REPLACE TABLE JobApplication(
id INT NOT NULL AUTO_INCREMENT,
responding_to INT,
applicant INT NOT NULL,
apply_date DATETIME DEFAULT NOW(),
status enum('Sent', 'Pending', 'Accepted', 'Denied'),
files_path VARCHAR(250),
PRIMARY KEY (id),
CONSTRAINT fk_JApp_TourGuide FOREIGN KEY (applicant) REFERENCES TourGuide(tgid) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_JApp_SimUser FOREIGN KEY (applicant) REFERENCES SimpleUser(suid) ON DELETE CASCADE ON UPDATE CASCADE
);

-- @block
show tables;


