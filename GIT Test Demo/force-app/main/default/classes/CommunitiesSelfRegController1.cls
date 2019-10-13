/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
public with sharing class CommunitiesSelfRegController1 {

  public String firstName {get; set;}
  public String lastName {get; set;}
  public String email {get; set;}
  public String password {get; set {password = value == null ? value : value.trim(); } }
  public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }
  public String communityNickname {get; set { communityNickname = value == null ? value : value.trim(); } }
  
  public CommunitiesSelfRegController1() {}
  
  @testVisible 
    private boolean isValidPassword() {
    return password == confirmPassword;
  }

  public PageReference registerUser() {
  
    // it's okay if password is null - we'll send the user a random password in that case
    if (!isValidPassword()) {
      System.debug(System.LoggingLevel.DEBUG, '## DEBUG: Password is invalid - returning null');
      ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.site.passwords_dont_match);
      ApexPages.addMessage(msg);
      return null;
    }  

    // 25-Jun-2013 Manu Erwin - Fixing insufficient code coverage for default Communities Apex Tests
    //String profileId = ''; // To be filled in by customer.
    //String roleEnum = ''; // To be filled in by customer.
    //String accountId = ''; // To be filled in by customer.

    // Set this to your main Communities Profile API Name
    String profileApiName = 'PowerCustomerSuccess';
    String profileId = [SELECT Id FROM Profile WHERE UserType = :profileApiName LIMIT 1].Id;
    List<Account> accounts = [SELECT Id FROM Account LIMIT 1];
    System.assert(!accounts.isEmpty(), 'There must be at least one account in this environment!');
    String accountId = accounts[0].Id;
    
    String userName = email;

    User u = new User();
    u.Username = userName;
    u.Email = email;
    u.FirstName = firstName;
    u.LastName = lastName;
    u.CommunityNickname = communityNickname;
    u.ProfileId = profileId;
    
    String userId = Site.createPortalUser(u, accountId, password);
   System.debug('==>>UserId'+userId);
    System.debug('==>>password'+password);
    if (userId != null) { 
      if (password != null && password.length() > 1) {
        System.debug(System.LoggingLevel.DEBUG, '## DEBUG: User creation successful and password ok - returning site.login');
        return Site.login(userName, password, null);
      }
      else {
        System.debug(System.LoggingLevel.DEBUG, '## DEBUG: User creation successful but password not ok - redirecting to self reg confirmation');
        PageReference page = System.Page.CommunitiesSelfRegConfirm;
        page.setRedirect(true);
        return page;
      }
    }
    System.debug(System.LoggingLevel.DEBUG, '## DEBUG: User creation not successful - returning null');
    return null;
  }
}