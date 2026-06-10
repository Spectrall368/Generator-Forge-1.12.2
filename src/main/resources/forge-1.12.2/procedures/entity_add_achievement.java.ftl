if(${input$entity} instanceof EntityPlayerMP) {
	Advancement _adv = ((EntityPlayerMP) ${input$entity}).mcServer.getAdvancementManager().getAdvancement(new ResourceLocation("${generator.map(field$achievement, "achievements")}"));
    AdvancementProgress _ap = ((EntityPlayerMP) ${input$entity}).getAdvancements().getProgress(_adv);
	if (!_ap.isDone()) {
		for (String criteria : _ap.getRemaningCriteria())
            ((EntityPlayerMP) ${input$entity}).getAdvancements().grantCriterion(_adv, criteria);
    }
}