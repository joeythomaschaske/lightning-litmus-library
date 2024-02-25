@IsTest
private class CaseServiceTest {
  @IsTest
  private static void calculatesHighPriority() {
    // given
    Account testAccount = new Account(
      Id = TestUtils.generateId(Account.SObjectType),
      AnnualRevenue = 1000000
    );
    Case testCase = new Case(AccountId = testAccount.Id);

    MockClass mockAccountSelector = new MockClass();
    MockMethod selectByAccountId = new MockMethod(
      'selectByAccountId',
      new List<Object>{ new List<Account>{ testAccount } }
    );
    mockAccountSelector.addMockMethod(selectByAccountId);
    AccountsSelector.instance = (AccountsSelector) Test.createStub(
      AccountsSelector.class,
      mockAccountSelector
    );

    // when
    CaseService.newInstance(new List<Case>{ testCase }).calculatePriority();

    // then
    Assert.areEqual('High', testCase.Priority, 'Expected High Priority');

    Assert.areEqual(
      1,
      selectByAccountId.getTimesCalled(),
      'Expected AccountsSelector.selectByAccountId to have been called once'
    );
    Assert.areEqual(
      new Set<Id>{ testAccount.Id },
      selectByAccountId.getNthCalledWith(1)[0],
      'Expected AccountsSelector.selectByAccountId to have been called with the test account id'
    );
  }
}
