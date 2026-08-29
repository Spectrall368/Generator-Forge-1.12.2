if (${input$entity} instanceof EntityLivingBase) {
    EntityLivingBase _entity = (EntityLivingBase) ${input$entity};
	_entity.getEntityAttribute(${generator.map(field$attribute, "attributes")}).getModifiers().forEach((_attribute) -> {
        if(_attribute.getName().equals(${'"' + modid + ':' + field$name + '"'})) _entity.getEntityAttribute(${generator.map(field$attribute, "attributes")}).removeModifier(_attribute);
	});
}