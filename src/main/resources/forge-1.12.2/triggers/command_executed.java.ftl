@SubscribeEvent public void onCommand(CommandEvent event){
		Entity entity = event.getSender().getCommandSenderEntity();
		if(entity != null){
		double i=entity.getPosition().getX();
		double j=entity.getPosition().getY();
		double k=entity.getPosition().getZ();
		String command=event.getCommand().getName();
		Map<String, Object> dependencies = new HashMap<>();
		dependencies.put("x" ,i);
		dependencies.put("y" ,j);
		dependencies.put("z" ,k);
		dependencies.put("world" ,entity.world);
		dependencies.put("entity" ,entity);
		dependencies.put("command" ,command);
		dependencies.put("event",event);
		this.executeProcedure(dependencies);
		}
		}
