@IsTest
public class MockClass implements System.StubProvider {
  private Map<String, MockMethod> mocksByName;

  public MockClass() {
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
