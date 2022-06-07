@isTest
public class CheckExecuteAnonymousTest {

    static testMethod void test(){
        System.debug(CheckExecuteAnonymous.getRun());
        CheckExecuteAnonymous.changeRun(false);
        System.debug(CheckExecuteAnonymous.getRun());
        CheckExecuteAnonymous.changeRun(true);
        System.debug(CheckExecuteAnonymous.getRun());
    }
}