*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: ZAG_VIEW_MAINT2.................................*
FORM GET_DATA_ZAG_VIEW_MAINT2.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZAGTEST_TABLE_1 WHERE
    PARAM_KEY LIKE 'ABC%' AND
(VIM_WHERETAB) .
    CLEAR ZAG_VIEW_MAINT2 .
ZAG_VIEW_MAINT2-MANDT =
ZAGTEST_TABLE_1-MANDT .
ZAG_VIEW_MAINT2-PARAM_KEY =
ZAGTEST_TABLE_1-PARAM_KEY .
    SELECT SINGLE * FROM ZAGTEST_TABLE_2 WHERE
DATA_KEY = ZAGTEST_TABLE_1-PARAM_KEY .
    IF SY-SUBRC EQ 0.
ZAG_VIEW_MAINT2-DATA_VALUE =
ZAGTEST_TABLE_2-DATA_VALUE .
    ENDIF.
<VIM_TOTAL_STRUC> = ZAG_VIEW_MAINT2.
    APPEND TOTAL.
  ENDSELECT.
  SORT TOTAL BY <VIM_XTOTAL_KEY>.
  <STATUS>-ALR_SORTED = 'R'.
*.check dynamic selectoptions (not in DDIC)...........................*
  IF X_HEADER-SELECTION NE SPACE.
    PERFORM CHECK_DYNAMIC_SELECT_OPTIONS.
  ELSEIF X_HEADER-DELMDTFLAG NE SPACE.
    PERFORM BUILD_MAINKEY_TAB.
  ENDIF.
  REFRESH EXTRACT.
ENDFORM.
*---------------------------------------------------------------------*
FORM DB_UPD_ZAG_VIEW_MAINT2 .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZAG_VIEW_MAINT2.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZAG_VIEW_MAINT2-ST_DELETE EQ GELOESCHT.
     READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
     IF SY-SUBRC EQ 0.
       DELETE EXTRACT INDEX SY-TABIX.
     ENDIF.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN GELOESCHT.
  SELECT SINGLE FOR UPDATE * FROM ZAGTEST_TABLE_1 WHERE
  PARAM_KEY = ZAG_VIEW_MAINT2-PARAM_KEY .
    IF SY-SUBRC = 0.
    DELETE ZAGTEST_TABLE_1 .
    ENDIF.
    SELECT SINGLE FOR UPDATE * FROM ZAGTEST_TABLE_2 WHERE
    DATA_KEY = ZAGTEST_TABLE_1-PARAM_KEY .
    IF SY-SUBRC = 0.
    DELETE ZAGTEST_TABLE_2 .
    ENDIF.
    IF STATUS-DELETE EQ GELOESCHT.
      READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY> BINARY SEARCH.
      DELETE EXTRACT INDEX SY-TABIX.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN OTHERS.
  SELECT SINGLE FOR UPDATE * FROM ZAGTEST_TABLE_1 WHERE
  PARAM_KEY = ZAG_VIEW_MAINT2-PARAM_KEY .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZAGTEST_TABLE_1.
    ENDIF.
ZAGTEST_TABLE_1-MANDT =
ZAG_VIEW_MAINT2-MANDT .
ZAGTEST_TABLE_1-PARAM_KEY =
ZAG_VIEW_MAINT2-PARAM_KEY .
    IF SY-SUBRC = 0.
    UPDATE ZAGTEST_TABLE_1 ##WARN_OK.
    ELSE.
    INSERT ZAGTEST_TABLE_1 .
    ENDIF.
    SELECT SINGLE FOR UPDATE * FROM ZAGTEST_TABLE_2 WHERE
    DATA_KEY = ZAGTEST_TABLE_1-PARAM_KEY .
      IF SY-SUBRC <> 0.   "insert preprocessing: init WA
        CLEAR ZAGTEST_TABLE_2.
ZAGTEST_TABLE_2-DATA_KEY =
ZAGTEST_TABLE_1-PARAM_KEY .
      ENDIF.
ZAGTEST_TABLE_2-DATA_VALUE =
ZAG_VIEW_MAINT2-DATA_VALUE .
    IF SY-SUBRC = 0.
    UPDATE ZAGTEST_TABLE_2 ##WARN_OK.
    ELSE.
    INSERT ZAGTEST_TABLE_2 .
    ENDIF.
    READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
    IF SY-SUBRC EQ 0.
      <XACT> = ORIGINAL.
      MODIFY EXTRACT INDEX SY-TABIX.
    ENDIF.
    <ACTION> = ORIGINAL.
    MODIFY TOTAL.
  ENDCASE.
ENDLOOP.
CLEAR: STATUS_ZAG_VIEW_MAINT2-UPD_FLAG,
STATUS_ZAG_VIEW_MAINT2-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZAG_VIEW_MAINT2.
  SELECT SINGLE * FROM ZAGTEST_TABLE_1 WHERE
PARAM_KEY = ZAG_VIEW_MAINT2-PARAM_KEY .
ZAG_VIEW_MAINT2-MANDT =
ZAGTEST_TABLE_1-MANDT .
ZAG_VIEW_MAINT2-PARAM_KEY =
ZAGTEST_TABLE_1-PARAM_KEY .
    SELECT SINGLE * FROM ZAGTEST_TABLE_2 WHERE
DATA_KEY = ZAGTEST_TABLE_1-PARAM_KEY .
    IF SY-SUBRC EQ 0.
ZAG_VIEW_MAINT2-DATA_VALUE =
ZAGTEST_TABLE_2-DATA_VALUE .
    ELSE.
      CLEAR SY-SUBRC.
      CLEAR ZAG_VIEW_MAINT2-DATA_VALUE .
    ENDIF.
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZAG_VIEW_MAINT2 USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZAG_VIEW_MAINT2-PARAM_KEY TO
ZAGTEST_TABLE_1-PARAM_KEY .
MOVE ZAG_VIEW_MAINT2-MANDT TO
ZAGTEST_TABLE_1-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZAGTEST_TABLE_1'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZAGTEST_TABLE_1 TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZAGTEST_TABLE_1'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

MOVE ZAGTEST_TABLE_1-PARAM_KEY TO
ZAGTEST_TABLE_2-DATA_KEY .
MOVE ZAG_VIEW_MAINT2-MANDT TO
ZAGTEST_TABLE_2-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZAGTEST_TABLE_2'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZAGTEST_TABLE_2 TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZAGTEST_TABLE_2'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*

* base table related FORM-routines.............
INCLUDE LSVIMFTX .
