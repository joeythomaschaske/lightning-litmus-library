@IsTest
private class CaseTriggerTest {
  @IsTest
  private static void calculatesPriorityOnInsert() {
    // given
    Case testCase = new Case(Subject = 'Test Case');

    MockClass mockCaseTriggerHandler = new MockClass();
    MockMethod mockCalculatePriority = new MockMethod(
      'calculatePriority',
      new List<Object>{ null }
    );
    mockCaseTriggerHandler.addMockMethod(mockCalculatePriority);
    CaseTriggerHandler.instance = (CaseTriggerHandler) Test.createStub(
      CaseTriggerHandler.class,
      mockCaseTriggerHandler
    );

    // when
    insert testCase;

    // then
    Assert.areEqual(1, mockCalculatePriority.getTimesCalled());

    List<Case> actualCases = (List<Case>) mockCalculatePriority.getNthCalledWith(
      1
    )[0];
    Assert.areEqual(1, actualCases.size());
    Assert.areEqual(testCase.Subject, actualCases[0].Subject);
  }
}
