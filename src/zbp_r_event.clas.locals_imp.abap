CLASS lhc_ZR_Event DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.



    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR ZR_Event RESULT result.

      METHODS get_global_authorizations_i FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR ZR_Registration RESULT result.

     METHODS ApproveRegistration FOR MODIFY
      IMPORTING keys FOR ACTION zr_registration~ApproveRegistration.

    METHODS RejectRegistration FOR MODIFY
      IMPORTING keys FOR ACTION zr_registration~RejectRegistration.

ENDCLASS.

CLASS lhc_ZR_Event IMPLEMENTATION.



  METHOD get_global_authorizations.
    result-%create = if_abap_behv=>auth-allowed.
  ENDMETHOD.

  METHOD get_global_authorizations_i.
  ENDMETHOD.

   METHOD ApproveRegistration.
    DATA message TYPE REF TO zcm_event_5.

    READ ENTITY IN LOCAL MODE zr_registration
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(registrations).

    LOOP AT registrations REFERENCE INTO DATA(registration).
      IF registration->Status = 'Approved'.
        message = NEW zcm_event_5( textid      = zcm_event_5=>already_approved ).
        APPEND VALUE #( %tky     = registration->%tky
                        %element = VALUE #( Status = if_abap_behv=>mk-on )
                        %msg     = message ) TO reported-zr_registration.
        APPEND VALUE #( %tky = registration->%tky ) TO failed-zr_registration.
        DELETE registrations INDEX sy-tabix.
        CONTINUE.
      ENDIF.

      IF registration->Status = 'Rejected'.
        message = NEW zcm_event_5( textid      = zcm_event_5=>already_rejected ).
        APPEND VALUE #( %tky     = registration->%tky
                        %element = VALUE #( Status = if_abap_behv=>mk-on )
                        %msg     = message ) TO reported-zr_registration.
        APPEND VALUE #( %tky = registration->%tky ) TO failed-zr_registration.
        DELETE registrations INDEX sy-tabix.
        CONTINUE.
      ENDIF.

      registration->Status = 'Approved'.
      message = NEW zcm_event_5( severity    = if_abap_behv_message=>severity-success
                                textid      = zcm_event_5=>approve_success ).
      APPEND VALUE #( %tky     = registration->%tky
                      %element = VALUE #( Status = if_abap_behv=>mk-on )
                      %msg     = message ) TO reported-zr_registration.
    ENDLOOP.


    MODIFY ENTITY IN LOCAL MODE zr_registration
           UPDATE FIELDS ( Status )
           WITH VALUE #( FOR t IN registrations
                         ( %tky = t-%tky Status = t-Status ) ).



  ENDMETHOD.

  METHOD RejectRegistration.
    DATA message TYPE REF TO zcm_event_5.

    READ ENTITY IN LOCAL MODE zr_registration
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(registrations).

    LOOP AT registrations REFERENCE INTO DATA(registration).
      IF registration->Status = 'Approved'.
        message = NEW zcm_event_5( textid      = zcm_event_5=>already_approved ).
        APPEND VALUE #( %tky     = registration->%tky
                        %element = VALUE #( Status = if_abap_behv=>mk-on )
                        %msg     = message ) TO reported-zr_registration.
        APPEND VALUE #( %tky = registration->%tky ) TO failed-zr_registration.
        DELETE registrations INDEX sy-tabix.
        CONTINUE.
      ENDIF.

      IF registration->Status = 'Rejected'.
        message = NEW zcm_event_5( textid      = zcm_event_5=>already_rejected ).
        APPEND VALUE #( %tky     = registration->%tky
                        %element = VALUE #( Status = if_abap_behv=>mk-on )
                        %msg     = message ) TO reported-zr_registration.
        APPEND VALUE #( %tky = registration->%tky ) TO failed-zr_registration.
        DELETE registrations INDEX sy-tabix.
        CONTINUE.
      ENDIF.

      registration->Status = 'Rejected'.
      message = NEW zcm_event_5( severity    = if_abap_behv_message=>severity-success
                                textid      = zcm_event_5=>reject_success ).
      APPEND VALUE #( %tky     = registration->%tky
                      %element = VALUE #( Status = if_abap_behv=>mk-on )
                      %msg     = message ) TO reported-zr_registration.
    ENDLOOP.


    MODIFY ENTITY IN LOCAL MODE zr_registration
           UPDATE FIELDS ( Status )
           WITH VALUE #( FOR t IN registrations
                         ( %tky = t-%tky Status = t-Status ) ).



  ENDMETHOD.



ENDCLASS.
