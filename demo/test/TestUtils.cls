@IsTest
public with sharing class TestUtils {
  private static Integer seed = 1;
  public static Id generateId(SObjectType objectType) {
    String result = String.valueOf(seed++);
    String prefix = objectType.getDescribe().getKeyPrefix();
    if (
      prefix == null &&
      objectType.getDescribe().getAssociateEntityType() == 'Share'
    ) {
      prefix = '02c';
    }
    return prefix + '0'.repeat(12 - result.length()) + result;
  }
}
