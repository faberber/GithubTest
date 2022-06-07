public class Translate {
    private final Applier_Form__c acct;
    public Translate(ApexPages.StandardController stdController) {

        this.acct = (Applier_Form__c)stdController.getRecord();

    }
  public String getBackbutton(){
         
       if('tr'==UserInfo.getLanguage()){ return 'Geri';}
        else{ return 'Back';}
       
    }
    public String getInformation(){
         
       if('tr'==UserInfo.getLanguage()){ return 'Kişisel Bilgiler';}
        else{ return 'Information';}
       
    }
    public String getSchoolInformation(){
         
       if('tr'==UserInfo.getLanguage()){ return 'Okul Bilgileri';}
        else{ return 'School Information';}
       
    }
     public String getExperienceInformation(){
         
       if('tr'==UserInfo.getLanguage()){ return 'Tecrübe';}
        else{ return 'Experience';}
    }
      public String getOther(){
         
       if('tr'==UserInfo.getLanguage()){ return 'Diğer';}
        else{ return 'Other';}
    }
      public String getCreateInformation(){
         
       if('tr'==UserInfo.getLanguage()){ return 'Oluşturan Bilgileri';}
        else{ return 'Create Information';}
    }
     public String getSummary(){
         
       if('tr'==UserInfo.getLanguage()){ return 'Başvuru Bilgileri';}
        else{ return 'Delivery Information';}
    }

}