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

  @isTest
  private static void handleMethodCall_storesInputsForAllCalls() {
    // given
    MockClass mockClass = new MockClass();
    MockMethod mockMethod = new MockMethod(
      'mockMethod',
      new List<Object>{ 'returnValue', 'returnValue3' }
    );
    mockClass.addMockMethod(mockMethod);
    MockMethod mockMethod2 = new MockMethod(
      'mockMethod2',
      new List<Object>{ 'returnValue2' }
    );
    mockClass.addMockMethod(mockMethod2);

    // when
    Account accountObject = new Account();
    mockClass.handleMethodCall(
      accountObject,
      'mockMethod',
      List<Account>.class,
      new List<Type> { String.class, Integer.class },
      new List<String> { 'arg1', 'arg2' },
      new List<Object> { 'arg1Value', 2 }
    );
    mockClass.handleMethodCall(
      accountObject,
      'mockMethod2',
      List<Contact>.class,
      new List<Type> { Boolean.class, Double.class },
      new List<String> { 'arg3', 'arg4' },
      new List<Object> { 'arg3Value', 2 }
    );
    mockClass.handleMethodCall(
      accountObject,
      'mockMethod',
      List<Account>.class,
      new List<Type> { String.class, Integer.class },
      new List<String> { 'arg1', 'arg2' },
      new List<Object> { 'arg1Value2', 7 }
    );

    // then
    MockMethodCall firstCall = mockClass.calls[0];
    Assert.areEqual(accountObject, firstCall.stubbedObject, 'first call object should be the accountObject');
    Assert.areEqual('mockMethod', firstCall.stubbedMethodName, 'first call should be to mockMethod');
    Assert.areEqual(List<Account>.class, firstCall.returnType, 'first call return type should be List<Account>.class');
    Assert.areEqual(new List<Type> { String.class, Integer.class }, firstCall.listOfParamTypes, 'first call param types should be [String.class, Integer.class]');
    Assert.areEqual(new List<String> { 'arg1', 'arg2' }, firstCall.listOfParamNames, 'first call param names should be [arg1, arg2]');
    Assert.areEqual(new List<Object> { 'arg1Value', 2 }, firstCall.listOfArgs, 'first call args should be [arg1Value, 2]');

    MockMethodCall secondCall = mockClass.calls[1];
    Assert.areEqual(accountObject, secondCall.stubbedObject, 'second call object should be the accountObject');
    Assert.areEqual('mockMethod2', secondCall.stubbedMethodName, 'second call should be to mockMethod2');
    Assert.areEqual(List<Contact>.class, secondCall.returnType, 'second call return type should be List<Contact>.class');
    Assert.areEqual(new List<Type> { Boolean.class, Double.class }, secondCall.listOfParamTypes, 'second call param types should be [Boolean.class, Double.class]');
    Assert.areEqual(new List<String> { 'arg3', 'arg4' }, secondCall.listOfParamNames, 'second call param names should be [arg3, arg4]');
    Assert.areEqual(new List<Object> { 'arg3Value', 2 }, secondCall.listOfArgs, 'second call args should be [arg3Value, 2]');

    MockMethodCall thirdCall = mockClass.calls[2];
    Assert.areEqual(accountObject, thirdCall.stubbedObject, 'third call object should be the accountObject');
    Assert.areEqual('mockMethod', thirdCall.stubbedMethodName, 'third call should be to mockMethod');
    Assert.areEqual(List<Account>.class, thirdCall.returnType, 'third call return type should be List<Account>.class');
    Assert.areEqual(new List<Type> { String.class, Integer.class }, thirdCall.listOfParamTypes, 'third call param types should be [String.class, Integer.class]');
    Assert.areEqual(new List<String> { 'arg1', 'arg2' }, thirdCall.listOfParamNames, 'third call param names should be [arg1, arg2]');
    Assert.areEqual(new List<Object> { 'arg1Value2', 7 }, thirdCall.listOfArgs, 'third call args should be [arg1Value2, 7]');
  }
}
