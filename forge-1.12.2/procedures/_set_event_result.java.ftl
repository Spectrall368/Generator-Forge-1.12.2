if(dependencies.get("event")!=null){
	Object _obj = dependencies.get("event");
	if(_obj instanceof net.minecraftforge.fml.common.eventhandler.Event) {
		net.minecraftforge.fml.common.eventhandler.Event _evt = (net.minecraftforge.fml.common.eventhandler.Event) _obj;
		if(_evt.hasResult())
			_evt.setResult(net.minecraftforge.fml.common.eventhandler.Event.Result.${result});
	}
}
