@isTest
public class BatchUserUpdateTest {
    static testMethod void batchUserUpdate()
    {
        TestDataFactory.createBaseTestData();
		Database.executeBatch(new BatchUserUpdate('Account'));
    }
}