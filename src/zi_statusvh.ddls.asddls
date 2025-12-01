@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Wertehilfe für Status'
@ObjectModel.resultSet.sizeCategory: #XS 
define view entity ZI_StatusVH
  as select distinct from zce_registration
{
  key status as Status
}
