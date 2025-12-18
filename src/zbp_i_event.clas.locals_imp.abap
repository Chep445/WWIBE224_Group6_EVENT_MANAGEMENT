*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

" --- TEIL 1: EVENT LOGIK ---
CLASS lhc_Event DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_features FOR FEATURES IMPORTING keys REQUEST requested_features FOR Event RESULT result.
    METHODS openEvent FOR MODIFY IMPORTING keys FOR ACTION Event~openEvent RESULT result.
    METHODS closeEvent FOR MODIFY IMPORTING keys FOR ACTION Event~closeEvent RESULT result.
    METHODS setInitialStatus FOR DETERMINE ON MODIFY IMPORTING keys FOR Event~setInitialStatus.
    METHODS calculateEventId FOR DETERMINE ON MODIFY IMPORTING keys FOR Event~calculateEventId.
    METHODS validateDates FOR VALIDATE ON SAVE IMPORTING keys FOR Event~validateDates.
ENDCLASS.

CLASS lhc_Event IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF ZICE_Event IN LOCAL MODE
      ENTITY Event FIELDS ( Status ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_events).

    result = VALUE #( FOR ls_event IN lt_events
      ( %tky = ls_event-%tky
        %action-openEvent  = COND #( WHEN ls_event-Status = 'O' THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )
        %action-closeEvent = COND #( WHEN ls_event-Status = 'C' THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )
      ) ).
  ENDMETHOD.

  METHOD setInitialStatus.
    MODIFY ENTITIES OF ZICE_Event IN LOCAL MODE
      ENTITY Event UPDATE FIELDS ( Status )
      WITH VALUE #( FOR key IN keys ( %tky = key-%tky Status = 'P' ) ).
  ENDMETHOD.

  METHOD calculateEventId.
    SELECT MAX( event_id ) FROM zce_event INTO @DATA(lv_max_id).

    MODIFY ENTITIES OF ZICE_Event IN LOCAL MODE
      ENTITY Event UPDATE FIELDS ( EventId )
      WITH VALUE #( FOR key IN keys ( %tky = key-%tky EventId = lv_max_id + 1 ) ).
  ENDMETHOD.

  METHOD validateDates.
    READ ENTITIES OF ZICE_Event IN LOCAL MODE
      ENTITY Event FIELDS ( StartDate EndDate ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_events).

    LOOP AT lt_events INTO DATA(ls_event).
      IF ls_event-StartDate < cl_abap_context_info=>get_system_date( ).
        APPEND VALUE #( %tky = ls_event-%tky ) TO failed-event.
        APPEND VALUE #( %tky = ls_event-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'Startdatum darf nicht in der Vergangenheit liegen.' )
                      ) TO reported-event.
      ENDIF.

      IF ls_event-EndDate < ls_event-StartDate.
        APPEND VALUE #( %tky = ls_event-%tky ) TO failed-event.
        APPEND VALUE #( %tky = ls_event-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'Enddatum darf nicht vor dem Startdatum liegen.' )
                      ) TO reported-event.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

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

ENDCLASS.

" --- TEIL 2: REGISTRATION LOGIK (WICHTIG: Hier drunter eingefügt) ---

CLASS lhc_Registration DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS approveRegistration FOR MODIFY IMPORTING keys FOR ACTION Registration~approveRegistration RESULT result.
    METHODS rejectRegistration FOR MODIFY IMPORTING keys FOR ACTION Registration~rejectRegistration RESULT result.
    METHODS determineInitValues FOR DETERMINE ON MODIFY IMPORTING keys FOR Registration~determineInitValues.
    METHODS validateMaxParticipants FOR VALIDATE ON SAVE IMPORTING keys FOR Registration~validateMaxParticipants.
ENDCLASS.

CLASS lhc_Registration IMPLEMENTATION.

  METHOD determineInitValues.
    " ID Berechnung und Status NEW setzen
    SELECT MAX( registration_id ) FROM zce_registration INTO @DATA(lv_max).

    MODIFY ENTITIES OF ZICE_Event IN LOCAL MODE
      ENTITY Registration UPDATE FIELDS ( Status RegistrationId )
      WITH VALUE #( FOR key IN keys ( %tky = key-%tky Status = 'New' RegistrationId = lv_max + 1 ) ).
  ENDMETHOD.

  METHOD validateMaxParticipants.
    " Max Participants Prüfung via Parent
    READ ENTITIES OF ZICE_Event IN LOCAL MODE
      ENTITY Registration BY \_Event FIELDS ( MaxParticipants )
      WITH CORRESPONDING #( keys ) RESULT DATA(lt_events).

    LOOP AT lt_events INTO DATA(ls_event).
      READ ENTITIES OF ZICE_Event IN LOCAL MODE
        ENTITY Event BY \_Registrations ALL FIELDS
        WITH VALUE #( ( %tky = ls_event-%tky ) ) RESULT DATA(lt_regs).

      IF lines( lt_regs ) > ls_event-MaxParticipants.
        LOOP AT keys INTO DATA(ls_key).
          APPEND VALUE #( %tky = ls_key-%tky ) TO failed-registration.
          APPEND VALUE #( %tky = ls_key-%tky
                          %msg = new_message_with_text(
                             severity = if_abap_behv_message=>severity-error
                             text = 'Maximale Teilnehmerzahl überschritten!' )
                        ) TO reported-registration.
        ENDLOOP.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD approveRegistration.
    READ ENTITIES OF ZICE_Event IN LOCAL MODE
      ENTITY Registration FIELDS ( Status ) WITH CORRESPONDING #( keys ) RESULT DATA(lt_regs).

    LOOP AT lt_regs INTO DATA(ls_reg).
      IF ls_reg-Status <> 'New'.
        APPEND VALUE #( %tky = ls_reg-%tky ) TO failed-registration.
        APPEND VALUE #( %tky = ls_reg-%tky %msg = new_message_with_text( text = 'Bereits verarbeitet!' ) ) TO reported-registration.
      ELSE.
        MODIFY ENTITIES OF ZICE_Event IN LOCAL MODE
          ENTITY Registration UPDATE FIELDS ( Status )
          WITH VALUE #( ( %tky = ls_reg-%tky Status = 'Approved' ) ).

        APPEND VALUE #( %tky = ls_reg-%tky
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                      text     = 'Teilnahme genehmigt!' ) ) TO reported-registration.
      ENDIF.
    ENDLOOP.

    READ ENTITIES OF ZICE_Event IN LOCAL MODE ENTITY Registration ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(regs).
    result = VALUE #( FOR r IN regs ( %tky = r-%tky %param = r ) ).
  ENDMETHOD.

  METHOD rejectRegistration.
    READ ENTITIES OF ZICE_Event IN LOCAL MODE
      ENTITY Registration FIELDS ( Status ) WITH CORRESPONDING #( keys ) RESULT DATA(lt_regs).

    LOOP AT lt_regs INTO DATA(ls_reg).
      IF ls_reg-Status <> 'New'.
        APPEND VALUE #( %tky = ls_reg-%tky ) TO failed-registration.
        APPEND VALUE #( %tky = ls_reg-%tky %msg = new_message_with_text( text = 'Bereits verarbeitet!' ) ) TO reported-registration.
      ELSE.
        MODIFY ENTITIES OF ZICE_Event IN LOCAL MODE
          ENTITY Registration UPDATE FIELDS ( Status )
          WITH VALUE #( ( %tky = ls_reg-%tky Status = 'Rejected' ) ).

        APPEND VALUE #( %tky = ls_reg-%tky
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                      text     = 'Teilnahme abgelehnt!' ) ) TO reported-registration.
      ENDIF.
    ENDLOOP.

    READ ENTITIES OF ZICE_Event IN LOCAL MODE ENTITY Registration ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(regs).
    result = VALUE #( FOR r IN regs ( %tky = r-%tky %param = r ) ).
  ENDMETHOD.

ENDCLASS.
