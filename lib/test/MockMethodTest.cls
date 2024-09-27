@IsTest
private with sharing class MockMethodTest {
  @IsTest
  private static void constructor_createsAMockMethod() {
    // given
    String methodName = 'methodName';
    List<Object> mockValues = new List<Object>();

    // when
    MockMethod mockMethod = new MockMethod(methodName, mockValues);

    // then
    System.assertEquals(methodName, mockMethod.getName());
  }

  @IsTest
  private static void handleMethodCall_handlesAMethodCall() {
    // given
    MockMethod mockMethod = new MockMethod(
      'method',
      new List<Object>{ 'methodReturnValue' }
    );

    // when
    String result = (String) mockMethod.handleMethodCall(
      new List<Object>{ 'methodParameters' }
    );

    // then
    System.assertEquals('methodReturnValue', result);
    System.assertEquals(1, mockMethod.getTimesCalled());
    System.assertEquals(
      new List<Object>{ 'methodParameters' },
      mockMethod.getNthCalledWith(1)
    );
  }

  @IsTest
  private static void constructor_throwsIllegalArgumentExceptionIfMethodNameIsBlank() {
    // given
    IllegalArgumentException thrownException;

    // when
    try {
      new MockMethod('', new List<Object>());
    } catch (IllegalArgumentException e) {
      thrownException = e;
    }

    // then
    System.assertNotEquals(null, thrownException);
    System.assertEquals(
      'methodName must not be empty',
      thrownException.getMessage()
    );
  }

  @IsTest
  private static void constructor_throwsIllegalArgumentExceptionIfMockValuesIsNull() {
    // given
    IllegalArgumentException thrownException;

    // when
    try {
      new MockMethod('mockMethod', null);
    } catch (IllegalArgumentException e) {
      thrownException = e;
    }

    // then
    System.assertNotEquals(null, thrownException);
    System.assertEquals(
      'mockValues must not be null',
      thrownException.getMessage()
    );
  }

  @IsTest
  private static void handleMethodCall_throwsExceptoinWhenDefined() {
    // given
    MockMethodTestException testException = new MockMethodTestException('Test Exception');

    MockMethod mockMethod = new MockMethod(
      'method',
      new List<Object>{ 'methodReturnValue', testException}
    );

    // when
    String result = (String) mockMethod.handleMethodCall(
      new List<Object>{ 'methodParameters' }
    );

    MockMethodTestException caughtException;
    try {
      mockMethod.handleMethodCall(new List<Object>{ 'methodParameters' });
    } catch (MockMethodTestException e) {
      caughtException = e;
    }

    // then
    Assert.areEqual(testException, caughtException, 'Exception should be thrown');
  }

  private class MockMethodTestException extends Exception {}
}
