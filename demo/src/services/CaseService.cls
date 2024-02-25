public with sharing class CaseService {
  private Integer HIGH_PRIORITY_REVENUE_ACCOUNT = 1000000;

  @TestVisible
  private static CaseService instance;

  private List<Case> cases;

  public CaseService(List<Case> cases) {
    this.cases = cases;
  }

  public static CaseService newInstance(List<Case> cases) {
    if (instance == null) {
      instance = new CaseService(cases);
    }
    return instance;
  }

  public void calculatePriority() {
    Set<Id> accountIds = new Set<Id>();

    for (Case c : cases) {
      accountIds.add(c.AccountId);
    }

    Map<Id, Account> accountsById = new Map<Id, Account>(
      AccountsSelector.newInstance().selectByAccountId(accountIds)
    );

    for (Case c : cases) {
      Account relatedAccount = accountsById.get(c.AccountId);

      if (relatedAccount.AnnualRevenue >= HIGH_PRIORITY_REVENUE_ACCOUNT) {
        c.Priority = 'High';
      } else {
        c.Priority = 'Medium';
      }
    }
  }
}
