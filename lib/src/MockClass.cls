@IsTest
public class MockClass implements System.StubProvider {

  /**
   * provides a list of called MockMethodCall objects in the order they were called.
   */
  public List<MockMethodCall> calls;

  private Map<String, MockMethod> mocksByName;

  public MockClass() {
    this.calls = new List<MockMethodCall>();
    this.mocksByName = new Map<String, MockMethod>();
  }

  /**
   * Adds a mock member method for the class being mocked
   * @param method The MockMethod for a member method of the class being mocked
   */
  public void addMockMethod(MockMethod method) {
    if (this.mocksByName.containsKey(method.getName())) {
      throw new MockException(method.getName() + ' is already mocked');
    }

    this.mocksByName.put(method.getName(), method);
  }

  /**
   * Used by the Stub API when tests are run
   */
  public Object handleMethodCall(
    Object stubbedObject,
    String stubbedMethodName,
    Type returnType,
    List<Type> listOfParamTypes,
    List<String> listOfParamNames,
    List<Object> listOfArgs
  ) {

    this.calls.add(
      new MockMethodCall(stubbedObject, stubbedMethodName, returnType, listOfParamTypes, listOfParamNames, listOfArgs)
    );

    String key = stubbedMethodName;
    MockMethod method = this.mocksByName.get(key);
    if (method == null) {
      throw new MockException(key + ' is not mocked');
    }

    return method.handleMethodCall(listOfArgs);
  }

  private class MockException extends Exception {
  }
}
