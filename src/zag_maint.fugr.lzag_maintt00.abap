*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZAGTEST_TABLE_1.................................*
DATA:  BEGIN OF STATUS_ZAGTEST_TABLE_1               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZAGTEST_TABLE_1               .
CONTROLS: TCTRL_ZAGTEST_TABLE_1
            TYPE TABLEVIEW USING SCREEN '2000'.
*...processing: ZAGTEST_TABLE_2.................................*
DATA:  BEGIN OF STATUS_ZAGTEST_TABLE_2               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZAGTEST_TABLE_2               .
CONTROLS: TCTRL_ZAGTEST_TABLE_2
            TYPE TABLEVIEW USING SCREEN '2001'.
*.........table declarations:.................................*
TABLES: *ZAGTEST_TABLE_1               .
TABLES: *ZAGTEST_TABLE_2               .
TABLES: ZAGTEST_TABLE_1                .
TABLES: ZAGTEST_TABLE_2                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
