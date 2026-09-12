<#assign attr = generator.map(field$attribute, "attributes")>
if (${input$entity} instanceof EntityLivingBase) {
	EntityLivingBase _entity = (EntityLivingBase) ${input$entity};
	AttributeModifier modifier = new AttributeModifier(UUID.fromString("${w.getUUID(field$name)}"), "${modid + ':' + field$name}", ${input$value}, ${field$operation?replace("ADD_VALUE", "0")?replace("ADD_MULTIPLIED_BASE", "1")?replace("ADD_MULTIPLIED_TOTAL", "2")});
	<#if field$permanent == "FALSE">
	modifier.setSaved(false);
    </#if>
	if (!_entity.getEntityAttribute(${attr}).hasModifier(modifier))
			_entity.getEntityAttribute(${attr}).applyModifier(modifier);
}