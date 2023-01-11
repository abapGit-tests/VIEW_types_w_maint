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
*...processing: ZAG_VIEW_MAINT..................................*
TABLES: ZAG_VIEW_MAINT, *ZAG_VIEW_MAINT. "view work areas
CONTROLS: TCTRL_ZAG_VIEW_MAINT
TYPE TABLEVIEW USING SCREEN '2002'.
DATA: BEGIN OF STATUS_ZAG_VIEW_MAINT. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZAG_VIEW_MAINT.
* Table for entries selected to show on screen
DATA: BEGIN OF ZAG_VIEW_MAINT_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZAG_VIEW_MAINT.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZAG_VIEW_MAINT_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZAG_VIEW_MAINT_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZAG_VIEW_MAINT.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZAG_VIEW_MAINT_TOTAL.

*.........table declarations:.................................*
TABLES: *ZAGTEST_TABLE_1               .
TABLES: *ZAGTEST_TABLE_2               .
TABLES: ZAGTEST_TABLE_1                .
TABLES: ZAGTEST_TABLE_2                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
