public class MyIdeaProfileExtension {
    private final ApexPages.IdeaStandardSetController ideaSetController;
    
    public MyIdeaProfileExtension(ApexPages.IdeaStandardSetController controller) {
        ideaSetController = (ApexPages.IdeaStandardSetController)controller;
    }
    
    public List<Idea> getModifiedIdeas() {
        Idea[] ideas = ideaSetController.getIdeaList();       
        return ideas;
    }
    
}