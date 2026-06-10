<#assign attr = generator.map(field$attribute, "attributes")>
if (${input$entity} instanceof EntityLivingBase) {
	EntityLivingBase _entity = (EntityLivingBase) ${input$entity};
	AttributeModifier modifier = new AttributeModifier(${'"' + modid + ':' + field$name + '"'}, ${input$value}, ${field$operation?replace("ADD_VALUE", "ADDITION")?replace("ADD_MULTIPLIED_BASE", "MULTIPLY_BASE")?replace("ADD_MULTIPLIED_TOTAL", "MULTIPLY_TOTAL")});
	if (_entity.getEntityAttribute(${attr}).getModifiers().stream().noneMatch((e) -> e.getName().equals(modifier.getName()))) {
		<#if field$permanent == "TRUE">
			_entity.getEntityAttribute(${attr}).applyModifier(modifier);
		<#else>
			_entity.getEntityAttribute(${attr}).applyModifier(modifier);
		</#if>
	}
}