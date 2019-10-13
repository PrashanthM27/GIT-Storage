public with sharing class zipcodeGeonames {
 public string temperature{set;get;}
 public string getCity{set;get;}
 public string getCountry{set;get;}
public zipCodeGeonames() {
    zipValue = '';
    inputCountry = '';
   
    zips = new List<zipInfo>();    
}

public class zipCodeException extends Exception {

}

public string zipValue {
    get { return zipValue; }
    set { zipValue = value; }
}   
public string inputCountry {
    get { return inputCountry; }
    set { inputCountry = value; }
}

public void zipSelection() {
    string value = Apexpages.currentPage().getParameters().get('myParam');
    system.debug('zipSelected is '+Apexpages.currentPage().getParameters().get('myParam')); 
}

public List<zipInfo> zips;
public zipInfo z = new zipInfo();       
public List<zipInfo> zipList {
    get { 
        return zips; 
    }
    set { zipList = value; }            
}

public class zipInfo {
    private string zip;
    private string city;    
    private string state;
    private string country;
    private integer zipIndex;       

    public string zipCity {
        get {return city;}
    }
    public string zipZip {
        get {return zip;}
    }
    public string zipState {
        get {return state;}
    }
    public string zipCountry {
        get {return country;}
    }
    public integer zipCount {
        get {return zipIndex;}
    }

    public void setzipCity(string value){
        city = value;
    }
    public void setzipZip(string value){
        zip = value;
    }
    public void setzipState(string value){
        state = value;
    }
    public void setzipCountry(string value){
        country = value;
    }
    public void setzipIndex(integer value){
        zipIndex = value;
    }

}

 private void printZipList()
{
    integer counter = 0;
    while (zips.size() > counter) {
        system.debug('zips['+counter+'] = '+zips[counter]);
        counter++;
    }               
}

public PageReference lookupList()
{
    boolean found = false;
    integer zipListIndex = 0;
    zips.clear();                   
    string geonamesEndpoint = 'http://api.zippopotam.us/us/'+zipValue;
    system.debug(LoggingLevel.Error, 'Calling endpoint='+geonamesEndpoint);

    HttpRequest req = new HttpRequest();
    HttpResponse res = new HttpResponse();
    Http http = new Http();
    req.setMethod('GET');
    req.setEndpoint(geonamesEndpoint);

    try {
        res = http.send(req);
        System.debug(res.getStatusCode());
        if (res.getStatusCode() != 200) {
                throw new zipCodeException(res.getStatus());
        }
        system.debug(LoggingLevel.Error,'res.body='+res.getBody());
    } catch (zipCodeException e) {
        system.debug(LoggingLevel.Error, 'Error HTTP response code = '+res.getStatusCode()+'; calling '+geonamesEndpoint );
        return null;
    }

    JSONParser parser = JSON.createParser(res.getBody());
    System.debug(parser);
    System.JSONToken token;
    string text;

    parser.nextToken();     
    System.debug(parser.gettext());
    parser.nextToken();     
    System.debug(parser.gettext());
    parser.nextToken();    
    System.debug(parser.gettext());    

    while((token = parser.nextToken()) != null) {
       
        if ((token = parser.getCurrentToken()) != JSONToken.END_OBJECT) {
            text = parser.getText();
            System.debug(text);
            if (token == JSONToken.FIELD_Name && text == 'country abbreviation') {
                token=parser.nextToken();
                z.setzipCountry(parser.getText());
                found = true;
            } else if (token == JSONToken.FIELD_Name && text == 'state') {
                token=parser.nextToken();
                z.setzipState(parser.getText());
                found = true;
            } else if (token == JSONToken.FIELD_Name && text == 'place name') {
                token=parser.nextToken(); 
                z.setzipCity(parser.getText());
                found = true;
            } else if (token == JSONToken.FIELD_Name && text == 'postalcode') {              
                token=parser.nextToken();
                z.setzipZip(parser.getText());
                found = true;
            }
        } else {               
            System.debug(parser.gettext());
            System.debug(found);
            if (found) {                        
                z.setzipIndex(zipListIndex);
                zipListIndex ++;
                zips.add(z);                    
                z = new zipInfo();              
                found = false;                  
            }
            System.debug(zips);                    
            token = parser.nextToken();
            if (token == JSONToken.END_ARRAY) {             
                    break;
            }
        }
    }        
    return null;
}
}