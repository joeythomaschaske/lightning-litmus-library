trigger CaseTrigger on Case(before insert) {
  CaseTriggerHandler handler = CaseTriggerHandler.newInstance();

  switch on Trigger.operationType {
    when BEFORE_INSERT {
      handler.calculatePriority(Trigger.new);
    }
  }
}
