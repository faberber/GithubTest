@isTest
public class CheckRecursiveTest {
    static testMethod void testRecursiveTest()
    {
        checkRecursive.testRun();
        checkRecursive.testRun();
    }
    static testMethod void testRecursiveFinanceCostCalculator()
    {
        checkRecursive.runFinanceCostCalculator();
        checkRecursive.runFinanceCostCalculator();
    }
    static testMethod void testRecursiveRun()
    {
        checkRecursive.runOnce();
        checkRecursive.testRun();
    }
     static testMethod void testRecursiveRun2()
    {
        checkRecursive.runOnce();
        checkRecursive.runOnce();
    }
       static testMethod void testRecursiveRun3()
    {
        checkRecursive.testRun();
        checkRecursive.runOnce();
    }
      static testMethod void testRecursiveRun4()
    {
        checkRecursive.runLast();
        checkRecursive.runLast();
    }
    static testMethod void testRecursiveRun5()
    {
        checkRecursive.runOnceTDOpp();
        checkRecursive.runOnceTDOpp();
    }
    static testMethod void testRecursiveRun6()
    {
        checkRecursive.runOnceCurrency();
        checkRecursive.runOnceCurrency();
    }
    static testMethod void testRecursiveRun7()
    {
        checkRecursive.runLastOli();
        checkRecursive.runLastOli();
    }
    static testMethod void testRecursiveRun8()
    {
        checkRecursive.testRun();
        checkRecursive.testRun();
    }
}