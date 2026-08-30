(${input$entity} instanceof EntityPlayerMP && ((EntityPlayerMP) ${input$entity}).world instanceof WorldServer && ((EntityPlayerMP) ${input$entity}).getAdvancements()
        .getProgress(((EntityPlayerMP) ${input$entity}).mcServer.getAdvancementManager().getAdvancement(new ResourceLocation("${generator.map(field$achievement, "achievements")}"))).isDone())
