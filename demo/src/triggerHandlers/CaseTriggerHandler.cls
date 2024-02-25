public with sharing class CaseTriggerHandler {
  @TestVisible
  private static CaseTriggerHandler instance;

  public static CaseTriggerHandler newInstance() {
    if (instance == null) {
      instance = new CaseTriggerHandler();
    }

    return instance;
  }

  public void calculatePriority(List<Case> cases) {
    CaseService.newInstance(cases).calculatePriority();
  }
}
