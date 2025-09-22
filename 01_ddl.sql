-- =========================================================================
/*
	Plik do zadania 1 i 2: 01_ddl.sql
	Tytuł: Tworzy strukturę tabel i tabele tymczasowe do porównania paczek danych.
	Data: 2025-08-31
	Uwagi: Dodatkowe kolumny i nazwy (tb_fact_history) zaproponowane przeze mnie na potrzeby zadania rekrutacyjnego
	W przypadku tabel tymczasowych dane znikają po zakończeniu transakcji (ON COMMIT DELETE ROWS)
*/
-- =========================================================================


CREATE TABLE fact_history (
    id_pack   	NUMBER       NOT NULL, 
    id_fact     NUMBER       NOT NULL,  
    first_name  VARCHAR2(50),
    surname     VARCHAR2(50),
    city        VARCHAR2(50),
    status      VARCHAR2(50),
    amount      NUMBER,
    score       NUMBER,
    level_num   NUMBER,
    start_date  DATE,
    end_date    DATE,
    update_date DATE 
);

ALTER TABLE fact_history
ADD CONSTRAINT pk_fact_history PRIMARY KEY (id_pack, id_fact);


CREATE GLOBAL TEMPORARY TABLE tmp_fact_history_compare_status (
    id_fact 	NUMBER,
    status  	NUMBER  -- 1 - MODIFIED, 2 - NEW, 3 - DELETED
) ON COMMIT DELETE ROWS;


CREATE GLOBAL TEMPORARY TABLE tmp_fact_history_compare_diff (
    id_fact        NUMBER             NOT NULL,
    col_name       VARCHAR2(100)      NOT NULL,
    col_type       VARCHAR2(30)       NOT NULL,
	col_old_value  VARCHAR2(4000), 
	col_new_value  VARCHAR2(4000) 
) ON COMMIT DELETE ROWS;
