/**
 * MockMethod class is a utility class for mocking method calls in unit tests.
 * It allows tracking the number of times a method is called, the parameters with
 * which it is called, and provides values to be returned in a predefined order.
 */

@IsTest
public class MockMethod {
  private String methodName;
  private List<Object> values;
  private Integer timesCalled;
  private List<List<Object>> callParameters;

  /**
   * Constructor for MockMethod class.
   *
   * @param methodName The name of the method being mocked.
   * @param mockValues The list of values to be returned in order when the method is called.
   * @throws IllegalArgumentException If methodName is empty or mockValues is null.
   */
  public MockMethod(String methodName, List<Object> mockValues) {
    if (String.isBlank(methodName)) {
      throw new IllegalArgumentException('methodName must not be empty');
    }
    if (mockValues == null) {
      throw new IllegalArgumentException('mockValues must not be null');
    }
    this.methodName = methodName;
    this.values = mockValues;
    this.timesCalled = 0;
    this.callParameters = new List<List<Object>>();
  }

  /**
   * Retrieves the name of the mocked method.
   *
   * @return The name of the mocked method.
   */
  public String getName() {
    return this.methodName;
  }

  /**
   * Handles a method call by updating the call count, storing the parameters,
   * and returning the next mock value.
   *
   * @param parameters The parameters with which the method is called.
   * @return The next predefined value.
   */
  public Object handleMethodCall(List<Object> parameters) {
    this.timesCalled += 1;
    this.callParameters.add(parameters);
    Object value = this.values.remove(0);
    if (value instanceof Exception) {
      throw (Exception) value;
    }
    return value;
  }

  /**
   * Retrieves the number of times the method has been called.
   *
   * @return The number of times the method has been called.
   */
  public Integer getTimesCalled() {
    return this.timesCalled;
  }

  /**
   * Retrieves the parameters with which the method was called the nth time.
   * Note: The nth argument must be positive integer starting from 1.
   *
   * @param n The call index.
   * @return The parameters of the nth method call.
   */
  public List<Object> getNthCalledWith(Integer n) {
    return this.callParameters.get(n - 1);
  }
}
