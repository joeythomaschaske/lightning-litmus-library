<div style="display: flex; justify-content: center;">
  <img src="logo.jpg" height="300" width="300" />
</div>


# Lightning Litmus Library (L3)

A super fast, lightweight, apex mocking and assertion library.

The L3 library provides a Salesforce testing utility built around the [Stub API](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_testing_stub_api.htm), enabling developers to mock Apex classes and methods and asserting their invocations with specific parameters and call counts.

The api was inspired by jest and allows for your apex tests to behave like your lwc tests.

Table of Contents

- [Project Structure](#project-structure)
- [Application and Testing Structure](#application-and-testing-structure)
- [API](#api)
  - [MockClass](#mockclass)
    - [Constructor](#constructor)
    - [addMockMethod](#addmockmethod)
    - [handleMethodCall](#handlemethodcall)
  - [MockMethod](#mockmethod)
    - [Constructor](#constructor-1)
    - [getName](#getname)
    - [getTimesCalled](#gettimescalled)
    - [getNthCalledWith](#getnthcalledwith)
- [Gotchas](#gotchas)

## Project Structure

- **[lib/src](lib/src):** Contains the source code of the testing utility library.
- **[lib/test](lib/test):** Contains test classes for the library.
- **[demo/](demo/):** Contains a demo showcasing the L3 library in action.

## Application and Testing Structure

To levergage this library you will need to provide a way for the mock classes to be injected from your tests to the classes that need to be mocked.

This can be as simple as exposing a `@TestVisible` instance in your classes and having a `static` method construct instances of your class and returning the mock

Example

```java
public with sharing class AccountsSelector {
    @TestVisible
    private static AccountsSelector instance;

    public static AccountsSelector newInstance() {
        if (instance == null) {
            instance = new AccountsSelector();
        }
        return instance;
    }

    public List<Account> getAccountsById(Set<Id> accountIds) {
        // code
    }
}
```

When you have a mechanism available to inject the mock you can begin using it.

```java
@IsTest
private class CaseServiceTest {

    @IsTest
    private static void calculatesHighPriorityFromAccountValue() {
        // given
        Account testAccount = new Account(
            Id = TestUtils.generateId(Account.SObjectType),
            AnnualRevenue = 1000000
        );
        Case testCase = new Case(
            AccountId = testAccount.Id
        );

        // mock setup
        MockClass mockAccountSelector = new MockClass();
        MockMethod selectByAccountId = new MockMethod('selectByAccountId', new List<Object> { new List<Account> {testAccount} });
        mockAccountSelector.addMockMethod(selectByAccountId);
        AccountsSelector.instance = (AccountsSelector) Test.createStub(AccountsSelector.class, mockAccountSelector);

        // when
        CaseService.newInstance(new List<Case>{testCase}).calculatePriority();

        // then
        Assert.areEqual('High', testCase.Priority, 'Expected High Priority');

        // mock assertions
        Assert.areEqual(1, selectByAccountId.getTimesCalled(), 'Expected AccountsSelector.selectByAccountId to have been called once');
        Assert.areEqual(new Set<Id>{ testAccount.Id }, selectByAccountId.getNthCalledWith(1)[0], 'Expected AccountsSelector.selectByAccountId to have been called with the test account id');
    }
}
```

## API

### MockClass

A `MockClass` represents a class to be mocked in a unit test. An instance of `MockClass` holds a list of `MockMethods` that belong to the class.

#### Constructor

`public MockMethod()`

```java
MockClass mockAccountSelector = new MockClass();
```

#### addMockMethod

Adds a `MockMethod` to the `MockClass`

`public void addMockMethod(MockMethod method)`

- <b>method</b>: Adds a `MockMethod` to the instance that is expected to be called in a unit test.

```java
MockClass mockAccountsSelector = new MockClass();
MockMethod mockSelectById = new MockMethod('selectById', mockListOfAccountsToReturn);
mockAccountsSelector.add(mockSelectById);
```

#### handleMethodCall

Called by the Stub API when invoking mocks in unit tests. Not very useful to call directly.

`public Object handleMethodCall`

- <b>stubbedObject</b>: The stubbed object
- <b>stubbedMethodName</b>: The name of the invoked method
- <b>returnType</b>: The return type of the invoked method.
- <b>listOfParamTypes</b>: A list of the parameter types of the invoked method.
- <b>listOfParamNames</b>: A list of the parameter names of the invoked method.
- <b>listOfArgs</b>: The actual argument values passed into this method at runtime.

#### calls
This parameter stores a list of `MockMethodCall` objects representing each call to the mock class. This is useful for
asserting the order of method calls in a unit test and the parameters passed to each method.


### MockMethod

A `MockMethod` represents a method to be mocked in a unit test. An instance of `MockMethod` holds all the parameters and returns the mocked values when invoked.

#### Constructor

`public MockMethod(String methodName, List<Object> mockValues)`

- <b>methodName</b>: The name of the method to be mocked
- <b>mockValues</b>: The list of values to return when mocked. Each item in the list represents a return value for an invocation. If a method is called multiple times, then the list should contain multiple values for each invocation.

```java
MockClass mockAccountsSelector = new MockClass();

List<Account> accountsToReturnOnFirstInvocation = new List<Account>{ /* specific accounts */ };
List<Account> accountsToReturnOnSecondInvocation = new List<Account> { /*  other specific accounts */ }
List<Object> returnValues = new List<Object> { accountsToReturnOnFirstInvocation, accountsToReturnOnSecondInvocation };

MockMethod mockSelectById = new MockMethod('selectById', returnValues);
mockAccountsSelector.addMockMethod(mockSelectById);
```
*Defining exceptions: If you want to throw an exception when the method is called, you can define an exception as a return value. The exception should be an instance of `Exception`.*

```java
MockClass mockAccountsSelector = new MockClass();

List<Account> accountsToReturnOnFirstInvocation = new List<Account>{ // specific accounts };
MyCustomException customException = new MyCustomException('Throw me'); // Exception to throw second time method is called
List<Object> returnValues = new List<Object> { accountsToReturnOnFirstInvocation, customException };

MockMethod mockSelectById = new MockMethod('selectById', returnValues);
mockAccountsSelector.addMockMethod(mockSelectById);
```

#### getName

Utility method used by `MockClass` to confirm mocks aren't overwritten.

`public String getName()`

```java
MockMethod mockSelectById = new MockMethod('selectById', mockListOfAccountsToReturn);

Assert.areEqual('selectById', mockSelectById.getName());
```

#### getTimesCalled

Returns the number of times the method was invoked in a unit test

`public Integer getTimesCalled`

```java
MockClass mockAccountsSelector = new MockClass();

List<Account> accountsToReturnOnFirstInvocation = new List<Account>{ // specific accounts };
List<Account> accountsToReturnOnSecondInvocation = new List<Account> { // other specific accounts }
List<Object> returnValues = new List<Object> { accountsToReturnOnFirstInvocation, accountsToReturnOnSecondInvocation };

MockMethod mockSelectById = new MockMethod('selectById', returnValues);
mockAccountsSelector.addMockMethod(mockSelectById);

// Call method under test

Assert.areEqual(2, mockSelectById.getTimesCalled());
```

#### getNthCalledWith

Returns the list of parameters the method was called with for a specific nth invocation

`public List<Object> getNthCalledWith(Integer n)`

- <b>n</b>: The nth invocation to return the invocation parameters for

```java
MockClass mockAccountsSelector = new MockClass();

Id account1Id = TestUtils.generateId(Account.SObjectType);
Id account2Id = TestUtils.generateId(Account.SObjectType);

List<Account> accountsToReturnOnFirstInvocation = new List<Account>{ new Account(Id = account1Id) };
List<Account> accountsToReturnOnSecondInvocation = new List<Account> { new Account(Id = account2Id) };
List<Object> returnValues = new List<Object> { accountsToReturnOnFirstInvocation, accountsToReturnOnSecondInvocation };

MockMethod mockSelectById = new MockMethod('selectById', returnValues);
mockAccountsSelector.addMockMethod(mockSelectById);

// Call method under test

List<Object> 1stInvocationParameters = mockSelectById.getNthCalledWith(1);
List<Object> 2ndInvocationParameters = mockSelectById.getNthCalledWith(2);
Assert.areEqual(account1Id, 1stInvocationParameters[0]);
Assert.areEqual(account2Id, 2ndInvocationParameters[0]);
```
### MockMethodCall
#### Attributes
    public Object stubbedObject;
    public String stubbedMethodName;
    public Type returnType;
    public List<Type> listOfParamTypes;
    public List<String> listOfParamNames;
    public List<Object> listOfArgs;
## Gotchas

- Static methods cannot be mocked by the stub api and thus affects this library as well.
- When mocking `void` methods, make sure you specify `null` as the return type. The stub api expects a return value regardless of if the method actually returns one.
- Unit tests are not a substitue to integration tests. Integration tests are still needed to make sure your application can run at scale and adhere to all the governor limits.
