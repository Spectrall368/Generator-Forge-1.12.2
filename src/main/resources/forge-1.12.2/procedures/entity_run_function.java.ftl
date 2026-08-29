<#include "mcelements.ftl">
{
	Entity _ent = ${input$entity};
	if(!_ent.world.isRemote && _ent.world.getMinecraftServer() != null) {
		FunctionObject _fopt = _ent.world.getMinecraftServer().getFunctionManager().getFunction(${toResourceLocation(input$function)});
		if(_fopt != null)
			_ent.world.getMinecraftServer().getFunctionManager().execute(_fopt, _ent);
	}
}