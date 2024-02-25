# Demo

The code under `src/` is a small application that calculates a case priority field based on the account's revenue it belongs to. The application uses selector, service, and trigger handler classes that are mocked.

The code under `test/` shows how the L3 library can be used to mock and assert the selectors, services, and trigger handlers are called.

## Demo Usage

To use the demo:

- Deploy the contents of the demo folder to your Salesforce org.
- Run the tests within the demo, i.e. `sf apex run test --wait 900`
