(${input$entity} instanceof EntityTameable && ${input$tamedBy} instanceof EntityLivingBase
        && ((EntityTameable) ${input$entity}).isOwner((EntityLivingBase) ${input$tamedBy}))
