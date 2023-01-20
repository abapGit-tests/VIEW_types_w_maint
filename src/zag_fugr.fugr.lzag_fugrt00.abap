*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZAG_VIEW_MAINT2.................................*
TABLES: ZAG_VIEW_MAINT2, *ZAG_VIEW_MAINT2. "view work areas
CONTROLS: TCTRL_ZAG_VIEW_MAINT2
TYPE TABLEVIEW USING SCREEN '2000'.
DATA: BEGIN OF STATUS_ZAG_VIEW_MAINT2. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZAG_VIEW_MAINT2.
* Table for entries selected to show on screen
DATA: BEGIN OF ZAG_VIEW_MAINT2_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZAG_VIEW_MAINT2.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZAG_VIEW_MAINT2_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZAG_VIEW_MAINT2_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZAG_VIEW_MAINT2.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZAG_VIEW_MAINT2_TOTAL.

*.........table declarations:.................................*
TABLES: ZAGTEST_TABLE_1                .
TABLES: ZAGTEST_TABLE_2                .
