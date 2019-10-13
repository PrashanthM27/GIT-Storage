trigger Trigger_Task_Send_Email on Task (before update) {
     Set<Id> ownerId=new Set<Id>();
     for(Task tsk:Trigger.New){
     ownerId.add(tsk.OwnerId);
     }
     Map<Id,User> user=new Map<Id,User>([Select Id,Name,Email from User where id=:ownerId]);
     for(Task tk:Trigger.New){
     User u=user.get(tk.OwnerId);
     Messaging.SingleEmailMessage msg=new Messaging.SingleEmailMessage();
     String[] toAddress=new String[]{u.Email};
     msg.setToAddresses(toAddress);
     msg.setSubject('A Task owned by you has been updated');
     
     String template='Hello'+tk.owner+'Your task has been modified.Here are the details';
     template+='Subject';
     template+='Due Date';
     template+='My Test Field';
     String duedate='';
     if(tk.ActivityDate==null)
     duedate='';
     else
      duedate=tk.ActivityDate.format();
     List<String> st=new List<String>();
     st.add(u.Name);
     st.add(tk.Subject);
     st.add(duedate);
     String formattedHTML=String.format(template,st);
     msg.setPlainTextBody(formattedHTML);
     Messaging.sendEMail(new Messaging.SingleEmailMessage[]{msg});
     }
     }