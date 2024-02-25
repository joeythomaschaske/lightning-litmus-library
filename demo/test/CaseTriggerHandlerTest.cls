@IsTest
private class CaseTriggerHandlerTest {
  @IsTest
  private static void calculatesPriority() {
    // given
    Case mockCase = new Case(Id = TestUtils.generateId(Case.SObjectType));

    MockClass mockCaseService = new MockClass();
    MockMethod mockCalculatePriority = new MockMethod(
      'calculatePriority',
      new List<Object>{ null }
    );
    mockCaseService.addMockMethod(mockCalculatePriority);
    CaseService.instance = (CaseService) Test.createStub(
      CaseService.class,
      mockCaseService
    );

    // when
    List<Case> mockCases = new List<Case>{ mockCase };
    CaseTriggerHandler handler = new CaseTriggerHandler();
    handler.calculatePriority(mockCases);

    // then
    Assert.areEqual(1, mockCalculatePriority.getTimesCalled());
  }
}
