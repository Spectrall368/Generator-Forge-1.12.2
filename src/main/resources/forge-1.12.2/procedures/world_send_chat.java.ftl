<@addTemplate file="utils/world/world_send_chat.java.ftl"/>
if (world instanceof WorldServer) {
	world.getMinecraftServer().getPlayerList().sendMessage(setComponents(new TextComponentString(${input$text})
		<#if (field$bold!"false")?lower_case == "true">, s -> s.setBold(true)</#if>
		<#if (field$italic!"false")?lower_case == "true">, s -> s.setItalic(true)</#if>
		<#if (field$underlined!"false")?lower_case == "true">, s -> s.setUnderlined(true)</#if>));
}