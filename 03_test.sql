-- =========================================================================
/*
	Plik do zadania 1 i 2: 03_ddl.sql
	Tytuł: Dane testowe dla sprawdzenia poprawnosci wykonywania programu + blok wywołania pakietu.
	Data: 2025-08-31
*/
-- =========================================================================


INSERT INTO fact_history (
    id_pack, id_fact, first_name, surname, city, status, amount, score, level_num, start_date, end_date, update_date
) VALUES
(1, 1001, 'Jan', 'Kowalski', 'Warszawa', 'ACTIVE', 1000, 95, 2, TO_DATE('2001-08-25','YYYY-MM-DD'), TO_DATE('2001-08-31','YYYY-MM-DD'), TO_DATE('2001-08-31','YYYY-MM-DD'));

INSERT INTO fact_history VALUES
(1, 1002, 'Anna', 'Nowak', 'Kraków', 'ACTIVE', 1500, 90, 3, TO_DATE('2005-08-25','YYYY-MM-DD'), TO_DATE('2031-08-25','YYYY-MM-DD'), TO_DATE('2031-08-25','YYYY-MM-DD'));

INSERT INTO fact_history VALUES
(2, 1001, 'Jan', 'Kowalski', 'Gdańsk', 'ACTIVE', 1100, 95, 2, TO_DATE('2001-08-25','YYYY-MM-DD'), TO_DATE('2031-08-25','YYYY-MM-DD'), TO_DATE('2031-08-25','YYYY-MM-DD'));

INSERT INTO fact_history VALUES
(2, 1003, 'Marek', 'Wiśniewski', 'Poznań', 'ACTIVE', 1200, 88, 1, TO_DATE('2010-08-25','YYYY-MM-DD'), TO_DATE('2031-08-25','YYYY-MM-DD'), TO_DATE('2031-08-25','YYYY-MM-DD'));

INSERT INTO fact_history VALUES
(1, 101, 'Jan', 'Kowalski', 'Warszawa', 'ACTIVE', 1000, 10, 1, TO_DATE('2001-01-01','YYYY-MM-DD'), TO_DATE('2031-12-31','YYYY-MM-DD'), TO_DATE('2001-06-01','YYYY-MM-DD'));

INSERT INTO fact_history VALUES
(1, 2002, 'Anna', 'Nowak', 'Kraków', 'ACTIVE', 1200, NULL, NULL, NULL, NULL, NULL);

INSERT INTO fact_history VALUES
(1, 102, 'Anna', 'Nowak', 'Gdańsk', 'ACTIVE', 2000, 20, 1, TO_DATE('2002-02-01','YYYY-MM-DD'), TO_DATE('2030-11-30','YYYY-MM-DD'), TO_DATE('2005-05-15','YYYY-MM-DD'));

INSERT INTO fact_history VALUES
(2, 102, 'Anna', 'Nowak', 'Gdańsk', 'INACTIVE', 2000, 20, 1, TO_DATE('2002-02-01','YYYY-MM-DD'), TO_DATE('2030-11-30','YYYY-MM-DD'), TO_DATE('2005-05-15','YYYY-MM-DD'));

INSERT INTO fact_history VALUES
(1, 103, 'Piotr', 'Wiśniewski', 'Poznań', 'ACTIVE', 3000, 30, 2, TO_DATE('2003-03-01','YYYY-MM-DD'), TO_DATE('2030-10-31','YYYY-MM-DD'), TO_DATE('2006-06-10','YYYY-MM-DD'));

INSERT INTO fact_history VALUES
(1, 106, 'Anna', 'Nowak', 'Kraków', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO fact_history VALUES
(2, 2001, 'Jan', 'Kowalski', 'Warszawa', 'ACTIVE', 1000, NULL, NULL, NULL, NULL, NULL);

INSERT INTO fact_history VALUES
(2, 104, 'Kasia', 'asdad', 'Łódź', 'ACTIVE', 4000, 40, 3, TO_DATE('2004-04-01','YYYY-MM-DD'), TO_DATE('2030-09-30','YYYY-MM-DD'), TO_DATE('2005-05-20','YYYY-MM-DD'));

INSERT INTO fact_history VALUES
(1, 2001, 'Jan', 'Kowalski', 'Warszawa', 'ACTIVE', 1000, NULL, NULL, NULL, NULL, NULL);

INSERT INTO fact_history VALUES
(1, 105, 'Jan', 'Kowalski', 'Warszawa', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO fact_history VALUES
(2, 106, 'Anna', 'Nowak', 'Kraków', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO fact_history VALUES
(2, 107, 'Piotr', 'Wiśniewski', 'Poznań', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

COMMIT;



BEGIN
   fact_history_compare_pkg.compare_fact(2, 1, TRUE);
END;
/
