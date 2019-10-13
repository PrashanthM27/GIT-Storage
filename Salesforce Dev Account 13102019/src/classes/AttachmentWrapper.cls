public class AttachmentWrapper{
public Attachment att{set;get;}
public Boolean Selected{set;get;}
public AttachmentWrapper(Attachment a){
att=a;
Selected=false;
}
}