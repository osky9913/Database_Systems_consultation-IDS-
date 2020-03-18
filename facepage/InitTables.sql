CREATE TABLE "ACCOUNT"
(
    "accountNumber" CHARACTER VARYING(100)
        CONSTRAINT "account_accountNumber_PK" PRIMARY KEY,
    "password" CHARACTER VARYING(100)
        CONSTRAINT "account_password_NN" NOT NULL
);

CREATE TABLE "USER"
(
    "loginName" CHARACTER VARYING(100)
        CONSTRAINT "user_loginName_PK" PRIMARY KEY,
    "nameSurname" CHARACTER VARYING(100)
        CONSTRAINT "user_nameSurname_NN" NOT NULL,
    "birthday" DATE
        CONSTRAINT "user_birthday_NN" NOT NULL,
    "email" CHARACTER VARYING(100)
        CONSTRAINT "user_email_NN" NOT NULL,
    "accountNumber" CHARACTER VARYING(100)
        CONSTRAINT "user_accountNumber_NN" NOT NULL
        CONSTRAINT "user_accountNumber_U" UNIQUE,

    CONSTRAINT "user_accountNumber_FK" FOREIGN KEY("accountNumber") REFERENCES ACCOUNT ("accountNumber") ON DELETE CASCADE
);

CREATE TABLE "PAGE"
(
    "pageName" CHARACTER VARYING(100)
        CONSTRAINT "page_pageName_U" UNIQUE NOT NULL,
    "accountNumber" CHARACTER VARYING(100)
        CONSTRAINT "page_accountNumber_U" UNIQUE NOT NULL,
    "visitsCount" INTEGER DEFAULT 0,

    CONSTRAINT "page_accountNumber_pageName_PK" PRIMARY KEY("pageName", "accountNumber"),
    CONSTRAINT "page_accountNumber_FK" FOREIGN KEY("accountNumber") REFERENCES ACCOUNT ("accountNumber") ON DELETE CASCADE

);

CREATE TABLE "COMPANY_ACCOUNT"
(
    "accountNumber" CHARACTER VARYING(100)
        CONSTRAINT "companyAccount_accountNumber_PK" PRIMARY KEY,
    "companyName" CHARACTER VARYING(100)
        CONSTRAINT "companyAccount_companyName_NN" NOT NULL,
    "fee" DECIMAL DEFAULT 0,

    CONSTRAINT "companyAccount_accountNumber_FK" FOREIGN KEY("accountNumber") REFERENCES ACCOUNT("accountNumber") ON DELETE CASCADE


);

CREATE TABLE "ADVERTISEMENT"
(
    "pageName" CHARACTER VARYING(100),
    "accountNumber" CHARACTER VARYING(100),
    "advertisement_accountNumber_FK" CHARACTER VARYING(100),
    "leaveRate" REAL DEFAULT 0,
    "clickCount" INTEGER DEFAULT 0,
    "conversionRate" REAL DEFAULT 0,
    "creatorsAccountNumber" CHARACTER VARYING(100)
        CONSTRAINT "advertisement_creatorsAccountNumber_NN" NOT NULL
        CONSTRAINT "advertisement_creatorsAccountNumber_FK" REFERENCES "COMPANY_ACCOUNT" ("accountNumber") ON DELETE  CASCADE ,

    CONSTRAINT "advertisement_pageName_accountNumber_PK" PRIMARY KEY("pageName", "accountNumber"),
    CONSTRAINT "advertisement_pageName_FK" FOREIGN KEY("pageName") REFERENCES "PAGE" ("pageName") ON DELETE CASCADE,
    CONSTRAINT "advertisement_accountNumber_FK" FOREIGN KEY("advertisement_accountNumber_FK") REFERENCES "PAGE" ("accountNumber") ON DELETE CASCADE
);



CREATE TABLE "PERSONAL_ACCOUNT"
(
    "accountNumber" CHARACTER VARYING(100)
        CONSTRAINT "personalAccount_accountNumber_PK" PRIMARY KEY,

    CONSTRAINT "personalAccount_accountNumber_FK" FOREIGN KEY("accountNumber") REFERENCES "ACCOUNT"("accountNumber") ON DELETE CASCADE
);



CREATE TABLE "PERMISSIONS"
(
    "pageName" CHARACTER VARYING(100),
    "accountNumber" CHARACTER VARYING(100),
    "permissionsAccountNumber" CHARACTER VARYING(100),

    CONSTRAINT "permissions_pageName_accountNumber_permissionsAccountNumber_PK" PRIMARY KEY("pageName", "accountNumber", "permissionsAccountNumber"),
    CONSTRAINT "permissions_pageName_FK" FOREIGN KEY("pageName") REFERENCES "PAGE"("pageName") ON DELETE CASCADE,
    CONSTRAINT "permissions_accountNumber_FK" FOREIGN KEY("accountNumber") REFERENCES "PAGE"("accountNumber") ON DELETE CASCADE,
    CONSTRAINT "permissions_permissionsAccountNumber_FK" FOREIGN KEY("permissionsAccountNumber") REFERENCES "ACCOUNT"("accountNumber") ON DELETE CASCADE



);

CREATE TABLE "ASSOCIATED_ACCOUNTS"
(
    "accountNumber1" CHARACTER VARYING(100),
    "accountNumber2" CHARACTER VARYING(100),

    CONSTRAINT "associatedAccounts_accountNumber1_accountNumber2_PK" PRIMARY KEY("accountNumber1", "accountNumber2"),
    CONSTRAINT "associatedAccounts_accountNumber1_FK" FOREIGN KEY("accountNumber1") REFERENCES "PERSONAL_ACCOUNT"("accountNumber") ON DELETE CASCADE,
    CONSTRAINT "associatedAccounts_accountNumber2_FK" FOREIGN KEY("accountNumber2") REFERENCES "PERSONAL_ACCOUNT"("accountNumber") ON DELETE CASCADE


);


