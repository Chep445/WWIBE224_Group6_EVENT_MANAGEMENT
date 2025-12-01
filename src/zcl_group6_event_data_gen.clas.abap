CLASS zcl_group6_event_data_gen DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_group6_event_data_gen IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    " Definition der internen Tabellen
    DATA: lt_events        TYPE TABLE OF zce_event,
          lt_participants  TYPE TABLE OF zce_participant,
          lt_registrations TYPE TABLE OF zce_registration.

    " 1. ALTE DATEN LÖSCHEN (Damit wir sauber starten)
    DELETE FROM zce_event.
    DELETE FROM zce_participant.
    DELETE FROM zce_registration.
    out->write( 'Alte Daten gelöscht.' ).

    " Admin-Daten vorbereiten
    GET TIME STAMP FIELD DATA(lv_timestamp).
    DATA(lv_user) = sy-uname.

    " ===================================================================
    " 2. EVENTS ERSTELLEN
    " ===================================================================
    " Wir speichern die UUIDs in Variablen, um sie später wiederzubenutzen
    DATA(lv_uuid_e1) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(lv_uuid_e2) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(lv_uuid_e3) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(lv_uuid_e4) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(lv_uuid_e5) = cl_system_uuid=>create_uuid_x16_static( ).

    lt_events = VALUE #(
      ( event_uuid = lv_uuid_e1 event_id = '10001' title = 'SAP Fiori Workshopss' location = 'Walldorf' start_date = '20251022' end_date = '20251024' max_participants = 30 status = 'O' description = 'Deep Dive Fiori'
        created_by = lv_user created_at = lv_timestamp last_changed_by = lv_user last_changed_at = lv_timestamp local_last_changed_at = lv_timestamp )

      ( event_uuid = lv_uuid_e2 event_id = '10002' title = 'Cloud ERP Summit' location = 'Berlin' start_date = '20251105' end_date = '20251107' max_participants = 500 status = 'P' description = 'Annual Summit'
        created_by = lv_user created_at = lv_timestamp last_changed_by = lv_user last_changed_at = lv_timestamp local_last_changed_at = lv_timestamp )

      ( event_uuid = lv_uuid_e3 event_id = '10003' title = 'ABAP RAP Training' location = 'Online' start_date = '20251201' end_date = '20251205' max_participants = 100 status = 'O' description = 'RAP for Beginners'
        created_by = lv_user created_at = lv_timestamp last_changed_by = lv_user last_changed_at = lv_timestamp local_last_changed_at = lv_timestamp )

      ( event_uuid = lv_uuid_e4 event_id = '10004' title = 'Oktoberfest Team Event' location = 'München' start_date = '20250920' end_date = '20250922' max_participants = 50 status = 'C' description = 'Social Event'
        created_by = lv_user created_at = lv_timestamp last_changed_by = lv_user last_changed_at = lv_timestamp local_last_changed_at = lv_timestamp )

      ( event_uuid = lv_uuid_e5 event_id = '10005' title = 'Clean Code Days' location = 'Hamburg' start_date = '20260115' end_date = '20260116' max_participants = 200 status = 'P' description = 'Better Code'
        created_by = lv_user created_at = lv_timestamp last_changed_by = lv_user last_changed_at = lv_timestamp local_last_changed_at = lv_timestamp )
    ).
    INSERT zce_event FROM TABLE @lt_events.
    out->write( |{ sy-dbcnt } Events eingefügt.| ).


    " ===================================================================
    " 3. TEILNEHMER ERSTELLEN
    " ===================================================================
    DATA(lv_uuid_p1) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(lv_uuid_p2) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(lv_uuid_p3) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(lv_uuid_p4) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(lv_uuid_p5) = cl_system_uuid=>create_uuid_x16_static( ).

    lt_participants = VALUE #(
      ( participant_uuid = lv_uuid_p1 participant_id = '50001' first_name = 'Max' last_name = 'Mustermann' email = 'max@test.com' phone = '0123456789'
        created_by = lv_user created_at = lv_timestamp last_changed_by = lv_user last_changed_at = lv_timestamp local_last_changed_at = lv_timestamp )

      ( participant_uuid = lv_uuid_p2 participant_id = '50002' first_name = 'Erika' last_name = 'Musterfrau' email = 'erika@test.com' phone = '987654321'
        created_by = lv_user created_at = lv_timestamp last_changed_by = lv_user last_changed_at = lv_timestamp local_last_changed_at = lv_timestamp )

      ( participant_uuid = lv_uuid_p3 participant_id = '50003' first_name = 'John' last_name = 'Doe' email = 'john@test.com' phone = '555-0199'
        created_by = lv_user created_at = lv_timestamp last_changed_by = lv_user last_changed_at = lv_timestamp local_last_changed_at = lv_timestamp )

      ( participant_uuid = lv_uuid_p4 participant_id = '50004' first_name = 'Jane' last_name = 'Smith' email = 'jane@test.com' phone = '555-0200'
        created_by = lv_user created_at = lv_timestamp last_changed_by = lv_user last_changed_at = lv_timestamp local_last_changed_at = lv_timestamp )

      ( participant_uuid = lv_uuid_p5 participant_id = '50005' first_name = 'Hans' last_name = 'Müller' email = 'hans@test.com' phone = '0176555444'
        created_by = lv_user created_at = lv_timestamp last_changed_by = lv_user last_changed_at = lv_timestamp local_last_changed_at = lv_timestamp )
    ).
    INSERT zce_participant FROM TABLE @lt_participants.
    out->write( |{ sy-dbcnt } Teilnehmer eingefügt.| ).


    " ===================================================================
    " 4. REGISTRIERUNGEN (TEILNAHMEN) ERSTELLEN
    " ===================================================================
    lt_registrations = VALUE #(
      " Max -> Fiori Workshop (New)
      ( registration_uuid = cl_system_uuid=>create_uuid_x16_static( ) registration_id = '90001'
        event_uuid = lv_uuid_e1 participant_uuid = lv_uuid_p1 status = 'New' remarks = 'Vegetarier'
        created_by = lv_user created_at = lv_timestamp last_changed_by = lv_user last_changed_at = lv_timestamp local_last_changed_at = lv_timestamp )

      " Erika -> Fiori Workshop (Approved)
      ( registration_uuid = cl_system_uuid=>create_uuid_x16_static( ) registration_id = '90002'
        event_uuid = lv_uuid_e1 participant_uuid = lv_uuid_p2 status = 'Approved' remarks = 'VIP Gast'
        created_by = lv_user created_at = lv_timestamp last_changed_by = lv_user last_changed_at = lv_timestamp local_last_changed_at = lv_timestamp )

      " John -> Cloud Summit (Rejected)
      ( registration_uuid = cl_system_uuid=>create_uuid_x16_static( ) registration_id = '90003'
        event_uuid = lv_uuid_e2 participant_uuid = lv_uuid_p3 status = 'Rejected' remarks = 'VIP Gast'
        created_by = lv_user created_at = lv_timestamp last_changed_by = lv_user last_changed_at = lv_timestamp local_last_changed_at = lv_timestamp )

      " Jane -> ABAP RAP (New)
      ( registration_uuid = cl_system_uuid=>create_uuid_x16_static( ) registration_id = '90004'
        event_uuid = lv_uuid_e3 participant_uuid = lv_uuid_p4 status = 'New' remarks = ''
        created_by = lv_user created_at = lv_timestamp last_changed_by = lv_user last_changed_at = lv_timestamp local_last_changed_at = lv_timestamp )

      " Hans -> Clean Code (New)
      ( registration_uuid = cl_system_uuid=>create_uuid_x16_static( ) registration_id = '90005'
        event_uuid = lv_uuid_e5 participant_uuid = lv_uuid_p5 status = 'New' remarks = 'Speaker'
        created_by = lv_user created_at = lv_timestamp last_changed_by = lv_user last_changed_at = lv_timestamp local_last_changed_at = lv_timestamp )
    ).

    INSERT zce_registration FROM TABLE @lt_registrations.
    out->write( |{ sy-dbcnt } Teilnahmen eingefügt.| ).

  ENDMETHOD.
ENDCLASS.
