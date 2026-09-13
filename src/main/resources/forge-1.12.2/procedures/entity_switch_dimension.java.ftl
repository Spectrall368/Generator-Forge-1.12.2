<#if field$dimension??><#--Here for legacy reasons as field$dimension does not exist in older workspaces-->
if (${input$entity} instanceof EntityPlayerMP && !${input$entity}.world.isRemote) {
    EntityPlayerMP _player = (EntityPlayerMP) ${input$entity};
	int destinationType = ${generator.map(field$dimension, "dimensions")};

	if (_player.dimension == destinationType) return;

	WorldServer nextWorld = _player.mcServer.getWorld(destinationType);
	if (nextWorld != null)
        _player.mcServer.getPlayerList().transferPlayerToDimension(_player, destinationType, (_w, _e, _yaw) -> {});
}
</#if>