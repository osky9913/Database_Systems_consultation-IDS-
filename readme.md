# Testovanie a správne spustenie skriptov

- Ako prvé je potreba inicializovať tabuľky, skripty na tento účel sú uložené v zložke __facepage__. Spúštajte v poradí(initTables->AddData->
AsoAcc). 
- Pre správnu demonštráciu funkčnosti skriptov sme pridali skripty na pridanie viacerých hodnôt, tieto sú v zložke __adding_more_data__.
Spúštajte v poradí(AddMoreData->AsoAcc)
- Skripty selectov nájdete v zložke __select_from_homework__

# Zadanie prvého selectu

1.) Kdo jsou přátelé uživatele/uživatelů se jménem Jan Novák? Očekává se tabulka výsledku se 
schématem (přihlašovací jméno Jana Nováka, e-mail Jana Nováka, přihlašovací jméno přítele, jméno a příjmení přítele, e-mail přítele).Uspořádejte podle přihlašovacího jména Jana Nováka.

- Informácie o uživateľoch máme v tabulke __"USER"__ a informácie o tom kto je s kým priateľ máme v tabulke __ASSOCIATED_ACCOUNTS__

- Tabulka __ASSOCIATED_ACCOUNTS__ môže mať aj v stĺpci __"accountNumber1"__ a v __"accountNumber2"__ ID pána Nováka
preto  najprv si túto tabuľku upravíme a to 

```sql
        (SELECT "accountNumber2" as "Jan", "accountNumber1" as "Friend" FROM ASSOCIATED_ACCOUNTS)
        UNION
        (SELECT "accountNumber1" as "Jan", "accountNumber2"  as Friend FROM ASSOCIATED_ACCOUNTS )
```
a z tabuľky __"USER"__ si vyberieme riadok kde meno sa volá "Jan Novak"

```sql
 ( SELECT "loginName" as "login_name1" , "email" as "email_1","nameSurname" as "name_1" , "accountNumber" FROM "USER" WHERE "nameSurname" = 'Jan Novak' ) t1

```

Tieto dve tabuľky sa napoja pomocou spoločného kľúča 
```sql
    ON  associated."Jan" = t1."accountNumber"
```
a pomocou príkazu inner join

```sql
( Select * From
    ( SELECT "loginName" as "login_name1" , "email" as "email_1","nameSurname" as "name_1" , "accountNumber" FROM "USER" WHERE "nameSurname" = 'Jan Novak' ) t1
inner join
    (
        (SELECT "accountNumber2" as "Jan", "accountNumber1" as "Friend" FROM ASSOCIATED_ACCOUNTS)
        UNION
        (SELECT "accountNumber1" as "Jan", "accountNumber2"  as Friend FROM ASSOCIATED_ACCOUNTS )
    ) associated
ON  associated."Jan" = t1."accountNumber"
) leftSide
```
Takto nám vznikne tabuľka s informáciami Jána Nováka a s kĺúčom priateľov Jána Nováka

Teraz si upravíme tabuľku __"USER"__ na informácie o priateľovi a to nasledovne

```sql
(select "accountNumber", "nameSurname" as "name_2" ,"loginName" as "login_name2", "email"  as "email_2" from "USER" ) rightside
```
a túto tabuľku znova napojíme pomocou inner join na základe kľúču priateľa 
```sql
ON leftSide."Friend" = rightside."accountNumber"
```

Následne nám vznikne celý kód:
```sql

Select  "login_name1",  "email_1" , "login_name2" , "name_2","email_2" From

(select "accountNumber", "nameSurname" as "name_2" ,"loginName" as "login_name2", "email"  as "email_2" from "USER" ) rightside

inner join

(Select * From
    ( SELECT "loginName" as "login_name1" , "email" as "email_1","nameSurname" as "name_1" , "accountNumber" FROM "USER" WHERE "nameSurname" = 'Jan Novak' ) t1
inner join
    (
        (SELECT "accountNumber2" as "Jan", "accountNumber1" as "Friend" FROM ASSOCIATED_ACCOUNTS)
        UNION
        (SELECT "accountNumber1" as "Jan", "accountNumber2"  as Friend FROM ASSOCIATED_ACCOUNTS )
    ) associated
ON  associated."Jan" = t1."accountNumber"
) leftSide
On leftSide."Friend" = rightside."accountNumber"
```

# Zadanie druhého selectu

 2.Kolik přátel a kolika různých ročníků (roků narození) mají jednotliví
 uživatelé se jménem Jan Novák? Očekává se tabulka výsledku se schématem
 (přihlašovací jméno Jana Nováka, e-mail Jana Nováka, počet přátel, počet ročníků).
 
- Ako prvé sme si z tabulky __ASSOCIATED_ACCOUNTS__ odstránili riadky s redundantnými priatelstvami ktoré boli len v opačnom poradí.
```sql
SELECT aa1."accountNumber1" account1, aa1."accountNumber2" account2
FROM ASSOCIATED_ACCOUNTS aa1
WHERE NOT EXISTS
    (SELECT *
    FROM ASSOCIATED_ACCOUNTS aa2
    WHERE (aa1."accountNumber1" = aa2."accountNumber2" AND aa1."accountNumber2" = aa2."accountNumber1"))
```

- V tabuľke všetkých užívateľov __"USER"__ hľadáme čísla účtov __"accountNumber"__ pre všetkých Janov Novákov, tento výber neskôr 
využijeme na vyhľadávanie Janovich priatelstiev.
```sql
SELECT "USER"."accountNumber" account3
    FROM "USER"
    WHERE "USER"."nameSurname" = 'Jan Novak'
```

- Tieto dva výbery teraz využijeme na nájdenie priatelstiev Jána Nováka. Teda hľadáme výskyt Janovho __"accountNumber"__ v skôr
 vytvorených stĺpcoch __account1__ a __account2__, prípadné vyskyty Jána nováka na riadku uložím do stĺpca __account3__ ktorý
 vyberám spoločne s počtom týchto vyskytov(počet priatelstiev Jana Nováka).
```sql
SELECT NovakAccounts.account3, COUNT(NovakAccounts.account3) count
FROM (
    SELECT aa1."accountNumber1" account1, aa1."accountNumber2" account2
    FROM ASSOCIATED_ACCOUNTS aa1
    WHERE NOT EXISTS
        (SELECT *
        FROM ASSOCIATED_ACCOUNTS aa2
        WHERE (aa1."accountNumber1" = aa2."accountNumber2" AND aa1."accountNumber2" = aa2."accountNumber1"))
    ) friendsData,
     (SELECT "USER"."accountNumber" account3
     FROM "USER"
     WHERE "USER"."nameSurname" = 'Jan Novak') NovakAccounts
WHERE NovakAccounts.account3 = friendsData.account2 OR  NovakAccounts.account3 = friendsData.account1
GROUP BY NovakAccounts.account3
```
- Následne už len vyberiem z __"USER"__ údaje zo zadania korešpondujúce pre __account3__, teda číslo účtu Jána Nováka.
```sql
SELECT "USER"."nameSurname",  "USER"."loginName", matches.count
FROM "USER",
    (SELECT NovakAccounts.account3, COUNT(NovakAccounts.account3) count
    FROM (
        SELECT aa1."accountNumber1" account1, aa1."accountNumber2" account2
        FROM ASSOCIATED_ACCOUNTS aa1
        WHERE NOT EXISTS
            (SELECT *
            FROM ASSOCIATED_ACCOUNTS aa2
            WHERE (aa1."accountNumber1" = aa2."accountNumber2" AND aa1."accountNumber2" = aa2."accountNumber1"))
        ) friendsData,
         (SELECT "USER"."accountNumber" account3
         FROM "USER"
         WHERE "USER"."nameSurname" = 'Jan Novak') NovakAccounts
    WHERE NovakAccounts.account3 = friendsData.account2 OR  NovakAccounts.account3 = friendsData.account1
    GROUP BY NovakAccounts.account3) matches
WHERE "USER"."accountNumber" = matches.account3;
```

# Zadanie tretieho selectu

3.) Kolik přátel a kolika různých ročníků (roků narození) mají
jednotliví uživatelé se jménem Jan Novák? Očekává se tabulka
výsledku se schématem (přihlašovací jméno Jana Nováka, e-mail
Jana Nováka, počet přátel, počet ročníků).
Musí být vidět i ty Jany Nováky, kteří nemají žádné přátele.

- Zadanie je veľmi podobné druhému zadaniu len s tým rozdielom že je treba vybrať aj Jánov Novákov bez priateľov. Toto dosiahneme pomocou unionu 
kde vyberáme loginName, nameSurname, email podľa zadania pričom pomocou letfJoinu kontroluje napojenie na tabuľku __ASSOCIATED_ACCOUNTS__
pričom kontrolujeme pomocou podmienky IS NULL pravu alebo ľavú časť __ASSOCIATED_ACCOUNTS__ a súčasne že na vyberanom riadku je údaj s __nameSurname__ 
Jan Novák.

```sql
--viď 2 select--
      +
UNION
SELECT "nameSurname", "loginName", 0
FROM "USER"  t1
LEFT JOIN ASSOCIATED_ACCOUNTS t2 ON  (t2."accountNumber1" = t1."accountNumber"  OR  "accountNumber2" = t1."accountNumber")
WHERE t1."nameSurname" = 'Jan Novak' AND (t2."accountNumber1" IS NULL  or t2."accountNumber2"  IS NULL);
```
#Zadanie štvrtého selectu

4.) Kdo má nejvíce přátel a kolik? Takových uživatelů může být
více. Očekává se tabulka výsledku se schématem (přihlašovací jméno,
jméno a příjmení, e-mail, počet přátel).

- Znova podobne ako v selectoch 2,3 hľadáme údaje priatelov v __ASSOCIATED_ACCOUNTS__, teraz už nie len pre Jána Nováka. Z tejto tabuľky
zistíme čísla účtov priatelov na základe ktorých tvoríme INNER JOIN na číslo účtov z __"USER__. Následne si len vyberiem údaje potrebné 
zo zadania a hlavne si ukladám počet priatelov __numOfFriends__ pre každého užívateľa s priateľmi. Dostávame výber __usersWithFriends__.
```sql
SELECT f2.login, f2.name, f2.mail, f2.count numOfFriends
FROM
    (SELECT u1."loginName" login, u1."nameSurname" name, u1."email" mail, COUNT(u1."loginName") as count
    FROM "USER" u1
    INNER JOIN (
        SELECT aa1."accountNumber1", aa1."accountNumber2"
        FROM ASSOCIATED_ACCOUNTS aa1
        WHERE NOT EXISTS
            (SELECT *
            FROM ASSOCIATED_ACCOUNTS aa2
            WHERE (aa1."accountNumber1" = aa2."accountNumber2" AND aa1."accountNumber2" = aa2."accountNumber1"))
        ) f1
    ON u1."accountNumber" = f1."accountNumber1" OR u1."accountNumber" = f1."accountNumber2"
    GROUP BY u1."loginName", u1."nameSurname", u1."email") f2
ORDER BY f2.count DESC
``` 
- ako posledné potrebujeme už len vyfiltrovať užívateľov ktorí majú maximálny počet. Ten zistím rovnako ako kód vyššie. Len s tým rozdielom
že vyberáme len údaj __MAX(t2.count)__, ktorý porovnávame s __numOfFriends__ z predchádzajúceho selectu, teda zostávajú len údaje, ktoré sa
rovnajú maximálnemu počtu priateľov.

```sql
SELECT *
FROM
    (SELECT f2.login, f2.name, f2.mail, f2.count numOfFriends
     FROM
        (SELECT u1."loginName" login, u1."nameSurname" name, u1."email" mail, COUNT(u1."loginName") as count
        FROM "USER" u1
        INNER JOIN (
            SELECT aa1."accountNumber1", aa1."accountNumber2"
            FROM ASSOCIATED_ACCOUNTS aa1
            WHERE NOT EXISTS
                (SELECT *
                FROM ASSOCIATED_ACCOUNTS aa2
                WHERE (aa1."accountNumber1" = aa2."accountNumber2" AND aa1."accountNumber2" = aa2."accountNumber1"))
            ) f1
        ON u1."accountNumber" = f1."accountNumber1" OR u1."accountNumber" = f1."accountNumber2"
        GROUP BY u1."loginName", u1."nameSurname", u1."email") f2) usersWithFriends
WHERE usersWithFriends.numOfFriends =
    (SELECT MAX(t2.count) maxCount
     FROM
        (SELECT u2."loginName", COUNT(u2."loginName") as count
        FROM "USER" u2
        INNER JOIN (
            SELECT aa1."accountNumber1", aa1."accountNumber2"
            FROM ASSOCIATED_ACCOUNTS aa1
            WHERE NOT EXISTS
                (SELECT *
                FROM ASSOCIATED_ACCOUNTS aa2
                WHERE (aa1."accountNumber1" = aa2."accountNumber2" AND aa1."accountNumber2" = aa2."accountNumber1"))
            ) t1
        ON u2."accountNumber" = t1."accountNumber1" OR u2."accountNumber" = t1."accountNumber2"
        GROUP BY u2."loginName") t2);
```

# Zadanie piateho selectu 

5.) Kteří uživatelé nemají žádného přítele? Očekává se tabulka výsledku se schématem
(přihlašovací jméno, jméno a příjmení, e-mail).
```sql
SELECT "loginName", "nameSurname","email"
FROM "USER"  t1
LEFT JOIN ASSOCIATED_ACCOUNTS t2 ON t2."accountNumber1" = t1."accountNumber"  OR  "accountNumber2" = t1."accountNumber"
WHERE t2."accountNumber1" IS NULL  or t2."accountNumber2"  IS NULL
```

- Vyberáme __loginName__, __nameSurname__,__email__ podľa zadania pričom pomocou letfJoinu kontroluje napojenie na tabuľku __ASSOCIATED_ACCOUNTS__
pričom kontrolujeme  pomocou podmienky IS NULL pravu alebo ľavú časť __ASSOCIATED_ACCOUNTS__.
