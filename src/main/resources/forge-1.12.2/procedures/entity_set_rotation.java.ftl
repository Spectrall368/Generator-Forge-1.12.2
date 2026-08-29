{
    	Entity _ent = ${input$entity};
    	_ent.rotationYaw = ${opt.toFloat(input$yaw)};
    	_ent.rotationPitch = ${opt.toFloat(input$pitch)};
    	_ent.setRenderYawOffset(_ent.rotationYaw);
    	_ent.setRotationYawHead(_ent.rotationYaw);
    	_ent.prevRotationYaw = _ent.rotationYaw;
    	_ent.prevRotationPitch = _ent.rotationYaw;
    	if(_ent instanceof EntityLivingBase) {
	        ((EntityLivingBase) _ent).prevRenderYawOffset = ((EntityLivingBase) _ent).rotationYaw;
	        ((EntityLivingBase) _ent).prevRotationYawHead = ((EntityLivingBase) _ent).rotationYaw;
	}
}