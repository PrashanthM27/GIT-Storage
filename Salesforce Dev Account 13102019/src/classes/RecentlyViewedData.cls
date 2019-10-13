public with sharing class RecentlyViewedData{
public List<RecentlyViewed> rv{set;get;}
public RecentlyViewedData(){
rv=new List<RecentlyViewed>();
}
public void getRecentData(){
rv=[Select Id,Name from RecentlyViewed where TYPE IN('Account') ORDER BY LastViewedDate DESC];
}
}