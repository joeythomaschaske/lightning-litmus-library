public with sharing class AccountsSelector {
  @TestVisible
  private static AccountsSelector instance;

  public static AccountsSelector newInstance() {
    if (instance == null) {
      instance = new AccountsSelector();
    }
    return instance;
  }

  public List<Account> selectByAccountId(Set<Id> accountIds) {
    return [SELECT Id, AnnualRevenue FROM Account WHERE Id IN :accountIds];
  }
}
