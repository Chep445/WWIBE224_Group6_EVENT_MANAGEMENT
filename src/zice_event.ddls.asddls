@AbapCatalog.viewEnhancementCategory: [#PROJECTION_LIST]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Event Interface View'
define root view entity ZICE_Event
  as select from zce_event
  composition [0..*] of ZICE_Registration as _Registrations
  
{
  key event_uuid            as EventUuid,
      event_id              as EventId,
      title                 as Title,
      location              as Location,
      start_date            as StartDate,
      end_date              as EndDate,
      max_participants      as MaxParticipants,
      status                as Status,
      description           as Description,

      /* Berechnetes Feld für StatusText (Anforderung PDF) */
      case status
        when 'P' then 'Planned'
        when 'O' then 'Open'
        when 'C' then 'Closed'
        else 'Unknown'
      end                   as StatusText,

      /* Administrative Felder */
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      /* Association */
     _Registrations
}
