({
    doInIt:function(component,event,helper){
        var countriesArray=[
            {text:"India",value:"India"},
             {text:"Japan",value:"Japan"}
        ];
    },
   dependantList:function(component,event,helper){
    India:[
    {text:"Hyderabad",value:"Hyderabad"},
 {text:"Chennai",value:"Chennai"},
 {text:"Bangalore",value:"Bangalore"}
    ];
 Japan:[
 {text:"Tokyo",value:"Tokyo"},
 {text:"Hiroshima",value:"Hiroshima"},
 {text:"Nagasaki",value:"Nagasaki"}
 ];
  component.set('v.Countries',countriesArray);
 component.set('v.DependantList',dependantList);
},
    pickChange:function(component,event,helper){
    var parentVal=component.find('v.Countries').get('v.value');
    component.set('v.DependantOptions',component.get('v.DependantList')[parentVal]);
}
})