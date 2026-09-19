<#include "procedures.java.ftl">
@Mod.EventBusSubscriber(Side.CLIENT) public class ${name}Procedure {
	@SubscribeEvent public static void onLeftClick(PlayerInteractEvent.LeftClickEmpty event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
				"x": "event.getPos().getX()",
				"y": "event.getPos().getY()",
				"z": "event.getPos().getZ()",
				"world": "event.getWorld()",
				"entity": "event.getEntityPlayer()"
			}/>
		</#assign>
		${JavaModName}.PACKET_HANDLER.sendToServer(new ${name}Message());
		execute(${dependenciesCode});
	}

	public static class ${name}Message implements IMessage {
		@Override public void toBytes(ByteBuf buffer) {}

		@Override public void fromBytes(ByteBuf buffer) {}
    }

	public static class ${name}MessageHandler implements IMessageHandler<${name}Message, IMessage> {
		@Override public IMessage onMessage(${name}Message message, MessageContext context) {
	    	EntityPlayerMP player = context.getServerHandler().player;
	    	player.getServerWorld().addScheduledTask(() -> {
				if (!player.world.isBlockLoaded(player.getPosition()))
					return;
				<#assign dependenciesCode>
					<@procedureDependenciesCode dependencies, {
						"x": "player.posX",
						"y": "player.posY",
						"z": "player.posZ",
						"world": "player.world",
						"entity": "player"
					}/>
				</#assign>
				execute(${dependenciesCode});
	    	});

            return null;
		}
	}

	public static void registerMessage() {
		${JavaModName}.addNetworkMessage(${name}MessageHandler.class, ${name}Message.class, Side.SERVER);
	}