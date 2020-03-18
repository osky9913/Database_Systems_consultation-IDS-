INSERT INTO "ACCOUNT"
("accountNumber", "password")
VALUES
('PEPA.DVORAK_23', 'RANDOMPASSWORD');

INSERT INTO "USER"
("loginName", "nameSurname", "birthday", "email", "accountNumber")
VALUES
('pepa', 'Pepa Dvořák', TO_DATE('1995-02-02', 'yyyy-mm-dd'), 'pepa@stud.fit.vutbr.cz', 'PEPA.DVORAK_23');

INSERT INTO "PAGE"
("pageName", "accountNumber")
VALUES
('pepaADS', 'PEPA.DVORAK_23');


INSERT INTO "PERMISSIONS"
("pageName", "accountNumber", "permissionsAccountNumber")
VALUES
('pepaADS', 'PEPA.DVORAK_23', 'PEPA.DVORAK_23');

INSERT INTO "COMPANY_ACCOUNT"
("accountNumber", "companyName")
VALUES
('PEPA.DVORAK_23', 'Pepa best advertisement');

INSERT INTO "PERSONAL_ACCOUNT"
("accountNumber")
VALUES
('PEPA.DVORAK_23');

INSERT INTO "ADVERTISEMENT"
("pageName", "accountNumber", "creatorsAccountNumber")
VALUES
('pepaADS', 'PEPA.DVORAK_23', 'PEPA.DVORAK_23');

SELECT * FROM "ACCOUNT";
SELECT * FROM "USER";
SELECT * FROM "PAGE";
SELECT * FROM "PERMISSIONS";
SELECT * FROM "COMPANY_ACCOUNT";
SELECT * FROM "ADVERTISEMENT";
