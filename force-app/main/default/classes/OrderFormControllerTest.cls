@isTest
public class OrderFormControllerTest{

    @isTest
    public static void unitTest(){
        Opportunity oppObj = new Opportunity();
        oppObj.Name = 'aa';
        oppObj.StageName = 'Test';
        oppObj.CloseDate = Date.today();
        insert oppObj;
        
        apexpages.currentpage().getparameters().put('id',oppObj.id);
        OrderFormController OFC = new OrderFormController();
    }
}