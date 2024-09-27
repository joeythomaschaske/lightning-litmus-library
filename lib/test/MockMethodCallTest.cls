@isTest
private with sharing class MockMethodCallTest {

  @isTest
  private static void constructor_assignsValuesCorrectly() {

    Object stubbedObject = 'stubbedObject';
    String stubbedMethodName = 'stubbedMethodName';
    Type returnType = String.class;
    List<Type> listOfParamTypes = new List<Type>{ String.class, Integer.class };
    List<String> listOfParamNames = new List<String>{ 'paramName' };
    List<Object> listOfArgs = new List<Object>{ 'paramValue' };

    Test.startTest();
    MockMethodCall call = new MockMethodCall(
      stubbedObject,
      stubbedMethodName,
      returnType,
      listOfParamTypes,
      listOfParamNames,
      listOfArgs
    );
    Test.stopTest();

    Assert.areEqual(stubbedObject, call.stubbedObject, 'stubbedObject should be assigned correctly');
    Assert.areEqual(stubbedMethodName, call.stubbedMethodName, 'stubbedMethodName should be assigned correctly');
    Assert.areEqual(returnType, call.returnType, 'returnType should be assigned correctly');
    Assert.areEqual(listOfParamTypes, call.listOfParamTypes, 'listOfParamTypes should be assigned correctly');
    Assert.areEqual(listOfParamNames, call.listOfParamNames, 'listOfParamNames should be assigned correctly');
    Assert.areEqual(listOfArgs, call.listOfArgs, 'listOfArgs should be assigned correctly');
  }
}