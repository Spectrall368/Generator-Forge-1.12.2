<#include "mcelements.ftl">
<#assign sound = generator.map(field$sound, "sounds")?replace("CUSTOM:", "${modid}:")>
<#if sound?has_content>
	if (!world.isRemote) {
		world.playSound(null, ${toBlockPos(input$x,input$y,input$z)},
	    	ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${sound}")),
			SoundCategory.${generator.map(field$soundcategory!"neutral", "soundcategories")}, ${opt.toFloat(input$level)}, ${opt.toFloat(input$pitch)});
	} else {
		world.playSound(${input$x}, ${input$y}, ${input$z},
	    	ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${sound}")),
			SoundCategory.${generator.map(field$soundcategory!"neutral", "soundcategories")}, ${opt.toFloat(input$level)}, ${opt.toFloat(input$pitch)}, false);
	}
</#if>