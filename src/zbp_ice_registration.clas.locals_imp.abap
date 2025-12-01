CLASS lhc_Registration DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    " Steuert Sichtbarkeit der Buttons
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Registration RESULT result.

    " Notwendig für RAP (Sicherheit)
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Registration RESULT result.

    " Die Actions
    METHODS approveRegistration FOR MODIFY
      IMPORTING keys FOR ACTION Registration~approveRegistration RESULT result.

    METHODS rejectRegistration FOR MODIFY
      IMPORTING keys FOR ACTION Registration~rejectRegistration RESULT result.

    " Setzt Status automatisch auf 'New'
    METHODS determineInitValues FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Registration~determineInitValues.

ENDCLASS.

CLASS lhc_registration IMPLEMENTATION.

  " 1. FEATURE CONTROL: Buttons sind IMMER AKTIV ("Dumm")
  METHOD get_instance_features.
    READ ENTITIES OF ZICE_Registration IN LOCAL MODE
      ENTITY Registration
      FIELDS ( Status ) WITH CORRESPONDING #( keys )
      RESULT DATA(registrations).

    " Wir setzen hart auf ENABLED, egal welcher Status
    result = VALUE #( FOR reg IN registrations
      ( %tky = reg-%tky
        %action-approveRegistration = if_abap_behv=>fc-o-enabled
        %action-rejectRegistration  = if_abap_behv=>fc-o-enabled
      ) ).
  ENDMETHOD.

  " 2. AUTHORIZATION: Alles erlauben
  METHOD get_instance_authorizations.
    result = VALUE #( FOR k IN keys (
                        %tky = k-%tky
                        %update = if_abap_behv=>auth-allowed
                        %action-approveRegistration = if_abap_behv=>auth-allowed
                        %action-rejectRegistration = if_abap_behv=>auth-allowed
                      ) ).
  ENDMETHOD.

  " 3. LOGIK: Approve (Genehmigen)
  METHOD approveRegistration.
    READ ENTITIES OF ZICE_Registration IN LOCAL MODE
      ENTITY Registration
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(registrations).

    LOOP AT registrations ASSIGNING FIELD-SYMBOL(<reg>).

      " Prüfung: Ist es bereits genau dieser Status?
      IF <reg>-Status = 'Approved'.
        " Fehler nur, wenn man versucht, ein bereits genehmigtes nochmal zu genehmigen
        APPEND VALUE #( %tky = <reg>-%tky ) TO failed-registration.
        APPEND VALUE #( %tky = <reg>-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'Fehler: Teilnahme ist bereits genehmigt.' )
                      ) TO reported-registration.
      ELSE.
        " Status ändern (Erlaubt von 'New' ODER 'Rejected')
        MODIFY ENTITIES OF ZICE_Registration IN LOCAL MODE
          ENTITY Registration
          UPDATE FIELDS ( Status ) WITH VALUE #( ( %tky = <reg>-%tky Status = 'Approved' ) ).

        APPEND VALUE #( %tky = <reg>-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-success
                                 text     = 'Teilnahme erfolgreich genehmigt.' )
                      ) TO reported-registration.
      ENDIF.
    ENDLOOP.

    " UI Refresh
    READ ENTITIES OF ZICE_Registration IN LOCAL MODE
      ENTITY Registration
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(updated_regs).
    result = VALUE #( FOR r IN updated_regs ( %tky = r-%tky %param = r ) ).
  ENDMETHOD.

  " 4. LOGIK: Reject (Ablehnen)
  METHOD rejectRegistration.
    READ ENTITIES OF ZICE_Registration IN LOCAL MODE
      ENTITY Registration
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(registrations).

    LOOP AT registrations ASSIGNING FIELD-SYMBOL(<reg>).

      " Prüfung: Ist es bereits genau dieser Status?
      IF <reg>-Status = 'Rejected'.
        " Fehler nur, wenn man versucht, ein bereits abgelehntes nochmal abzulehnen
        APPEND VALUE #( %tky = <reg>-%tky ) TO failed-registration.
        APPEND VALUE #( %tky = <reg>-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'Fehler: Teilnahme ist bereits abgelehnt.' )
                      ) TO reported-registration.
      ELSE.
        " Status ändern (Erlaubt von 'New' ODER 'Approved')
        MODIFY ENTITIES OF ZICE_Registration IN LOCAL MODE
          ENTITY Registration
          UPDATE FIELDS ( Status ) WITH VALUE #( ( %tky = <reg>-%tky Status = 'Rejected' ) ).

        APPEND VALUE #( %tky = <reg>-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-success
                                 text     = 'Teilnahme abgelehnt.' )
                      ) TO reported-registration.
      ENDIF.
    ENDLOOP.

    " UI Refresh
    READ ENTITIES OF ZICE_Registration IN LOCAL MODE
      ENTITY Registration
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(updated_regs).
    result = VALUE #( FOR r IN updated_regs ( %tky = r-%tky %param = r ) ).
  ENDMETHOD.

  " 5. LOGIK: Initialwert (New)
  METHOD determineInitValues.
    READ ENTITIES OF ZICE_Registration IN LOCAL MODE
      ENTITY Registration
      FIELDS ( Status ) WITH CORRESPONDING #( keys )
      RESULT DATA(registrations).

    DELETE registrations WHERE Status IS NOT INITIAL.
    CHECK registrations IS NOT INITIAL.

    MODIFY ENTITIES OF ZICE_Registration IN LOCAL MODE
      ENTITY Registration
      UPDATE FIELDS ( Status )
      WITH VALUE #( FOR r IN registrations ( %tky = r-%tky Status = 'New' ) ).
  ENDMETHOD.

ENDCLASS.
