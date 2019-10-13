public class mutiselectListDemo 
{
    private List<SelectOption> multiSelectOptionList =  new List<SelectOption>();
   
    public mutiselectListDemo()
    {
        multiSelectOptionList.add(new SelectOption('Option1' , 'Option1'));
        multiSelectOptionList.add(new SelectOption('Option2' , 'Option2'));
        multiSelectOptionList.add(new SelectOption('Option3' , 'Option3'));
        multiSelectOptionList.add(new SelectOption('Option4' , 'Option4'));
        multiSelectOptionList.add(new SelectOption('Option5' , 'Option5'));
    }

    public string selectedOptions {get;set;}
    
    
    
    // this will set value separated by ','
    public List<String> selectedOptionsList
    {   
        get; 
        set
            {
                selectedOptions = null;
                if(value != null && value.size() > 0)
                    {
                        Boolean addSeperater = false;
                        for(String le : value)
                            {
                                if(addSeperater)
                                    selectedOptions = selectedOptions + ',' + le;
                                else
                                    {
                                        selectedOptions = le;
                                        addSeperater = true;
                                    }
                            }
                    }
            }
    }
    public List<SelectOption> multiSelectOptions
        {   
            get
                {
                    return multiSelectOptionList;
                }
            set;
        }

    public PageReference showSelected()
        {
            return ApexPages.currentPage();
        }

     public string newOption{get;set;}
     public PageReference  addOption()
         {
            if(newOption != null && newOption.length() > 0)
            multiSelectOptionList.add(new SelectOption(newOption , newOption));
            newOption  = null;
            return ApexPages.currentPage();
        }
}