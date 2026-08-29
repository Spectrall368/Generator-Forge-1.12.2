if(${input$entity} instanceof EntityPlayerMP) {
	Advancement _adv = ((EntityPlayerMP) ${input$entity}).mcServer.getAdvancementManager().getAdvancement(new ResourceLocation("${generator.map(field$achievement, "achievements")}"));
	if (_adv != null) {
		AdvancementProgress _ap = ((EntityPlayerMP) ${input$entity}).getAdvancements().getProgress(_adv);
		if (_ap.isDone()) {
			for (String criteria : _ap.getCompletedCriteria())
				((EntityPlayerMP) ${input$entity}).getAdvancements().revokeCriterion(_adv, criteria);
		}
	}
}
