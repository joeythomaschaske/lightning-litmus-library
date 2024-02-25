@IsTest
private with sharing class MockClassTest {
  @IsTest
  private static void handleMethodCall_handlesMethodCall() {
    // given
    MockClass mockClass = new MockClass();
    MockMethod mockMethod = new MockMethod(
      'mockMethod',
      new List<Object>{ 'returnValue' }
    );
    mockClass.addMockMethod(mockMethod);

    // when
    String result = (String) mockClass.handleMethodCall(
      null,
      'mockMethod',
      null,
      null,
      null,
      null
    );

    // then
    System.assertEquals('returnValue', result);
  }

  @IsTest
  private static void addMockMethod_throwsExceptionIfMethodMockedMoreThanOnce() {
    // given
    MockClass mockClass = new MockClass();
    MockMethod mockMethod = new MockMethod(
      'mockMethod',
      new List<Object>{ 'returnValue' }
    );
    mockClass.addMockMethod(mockMethod);

    // when
    Exception thrownException;
    try {
      mockClass.addMockMethod(mockMethod);
    } catch (Exception e) {
      thrownException = e;
    }

    // then
    System.assertNotEquals(null, thrownException);
    System.assertEquals(
      'mockMethod is already mocked',
      thrownException.getMessage()
    );
  }

  @IsTest
  private static void handleMethodCall_throwsExceptionIfMethodIsNotMocked() {
    // given
    MockClass mockClass = new MockClass();

    // when
    Exception thrownException;
    try {
      mockClass.handleMethodCall(null, 'mockMethod', null, null, null, null);
    } catch (Exception e) {
      thrownException = e;
    }

    // then
    System.assertNotEquals(null, thrownException);
    System.assertEquals(
      'mockMethod is not mocked',
      thrownException.getMessage()
    );
  }
}
