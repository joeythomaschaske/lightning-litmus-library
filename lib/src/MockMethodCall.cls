public with sharing class MockMethodCall {

  public Object stubbedObject;
  public String stubbedMethodName;
  public Type returnType;
  public List<Type> listOfParamTypes;
  public List<String> listOfParamNames;
  public List<Object> listOfArgs;

  public MockMethodCall(
    Object stubbedObject,
    String stubbedMethodName,
    Type returnType,
    List<Type> listOfParamTypes,
    List<String> listOfParamNames,
    List<Object> listOfArgs
  ) {
    this.stubbedObject = stubbedObject;
    this.stubbedMethodName = stubbedMethodName;
    this.returnType = returnType;
    this.listOfParamTypes = listOfParamTypes;
    this.listOfParamNames = listOfParamNames;
    this.listOfArgs = listOfArgs;
  }
}