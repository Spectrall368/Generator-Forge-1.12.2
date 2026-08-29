(new Vec3d(${input$entity}.world.rayTraceBlocks(${input$entity}.getPositionEyes(1f), ${input$entity}.getPositionEyes(1f)
        .add(${input$entity}.getLook(1f).x * ${input$maxdistance}, ${input$entity}.getLook(1f).y * ${input$maxdistance}, ${input$entity}.getLook(1f).z * ${input$maxdistance}),
        ${field$fluid_mode != "NONE"}, ${field$block_mode != "OUTLINE"}, true).getBlockPos()))