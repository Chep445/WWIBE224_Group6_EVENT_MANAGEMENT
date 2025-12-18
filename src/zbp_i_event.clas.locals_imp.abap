CLASS lhc_Event DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS openEvent FOR MODIFY IMPORTING keys FOR ACTION Event~openEvent RESULT result.
    METHODS closeEvent FOR MODIFY IMPORTING keys FOR ACTION Event~closeEvent RESULT result.
    METHODS setInitialStatus FOR DETERMINE ON MODIFY IMPORTING keys FOR Event~setInitialStatus.
    METHODS calculateEventId FOR DETERMINE ON MODIFY IMPORTING keys FOR Event~calculateEventId.
    METHODS validateDates FOR VALIDATE ON SAVE IMPORTING keys FOR Event~validateDates.
ENDCLASS.
CLASS lhc_Event IMPLEMENTATION.
  METHOD openEvent.
    MODIFY ENTITIES OF ZICE_Event IN LOCAL MODE
      ENTITY Event UPDATE FIELDS ( Status )
      WITH VALUE #( FOR key IN keys ( %tky = key-%tky Status = 'O' ) ).
    READ ENTITIES OF ZICE_Event IN LOCAL MODE
      ENTITY Event ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(events).
    result = VALUE #( FOR ev IN events ( %tky = ev-%tky %param = ev ) ).
  ENDMETHOD.
  METHOD closeEvent.
    MODIFY ENTITIES OF ZICE_Event IN LOCAL MODE
      ENTITY Event UPDATE FIELDS ( Status )
      WITH VALUE #( FOR key IN keys ( %tky = key-%tky Status = 'C' ) ).
    READ ENTITIES OF ZICE_Event IN LOCAL MODE
      ENTITY Event ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(events).
    result = VALUE #( FOR ev IN events ( %tky = ev-%tky %param = ev ) ).
  ENDMETHOD.
  METHOD setInitialStatus.
    MODIFY ENTITIES OF ZICE_Event IN LOCAL MODE
      ENTITY Event UPDATE FIELDS ( Status )
      WITH VALUE #( FOR key IN keys ( %tky = key-%tky Status = 'P' ) ).
  ENDMETHOD.
  METHOD calculateEventId.
    SELECT MAX( event_id ) FROM zce_event INTO @DATA(lv_max).
    MODIFY ENTITIES OF ZICE_Event IN LOCAL MODE
      ENTITY Event UPDATE FIELDS ( EventId )
      WITH VALUE #( FOR key IN keys ( %tky = key-%tky EventId = lv_max + 1 ) ).
  ENDMETHOD.
  METHOD validateDates.
    READ ENTITIES OF ZICE_Event IN LOCAL MODE
      ENTITY Event FIELDS ( StartDate EndDate )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_events).
    LOOP AT lt_events INTO DATA(ls_event).
      IF ls_event-StartDate < cl_abap_context_info=>get_system_date( ).
        APPEND VALUE #( %tky = ls_event-%tky ) TO failed-event.
        APPEND VALUE #(
          %tky = ls_event-%tky
          %msg = new_message_with_text(
                    severity = if_abap_behv_message=>severity-error
                    text     = 'Start date cannot be in the past' ) ) TO reported-event.
      ENDIF.
      IF ls_event-EndDate < ls_event-StartDate.
        APPEND VALUE #( %tky = ls_event-%tky ) TO failed-event.
        APPEND VALUE #(
          %tky = ls_event-%tky
          %msg = new_message_with_text(
                    severity = if_abap_behv_message=>severity-error
                    text     = 'End date cannot be before start date' ) ) TO reported-event.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
