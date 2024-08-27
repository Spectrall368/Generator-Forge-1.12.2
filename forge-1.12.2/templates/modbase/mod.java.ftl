<#-- @formatter:off -->
package ${package};

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

@Mod(modid = ${JavaModName}.MODID, name = "${settings.getModName()}", version = "${settings.getCleanVersion()}"
<#if settings.isServerSideOnly()>, acceptableRemoteVersions = "*"</#if>) public class ${JavaModName} {

	public static final Logger LOGGER = LogManager.getLogger(${JavaModName}.class);
	public static final String MODID = "${modid}";

	public static final SimpleNetworkWrapper PACKET_HANDLER =
		NetworkRegistry.INSTANCE.newSimpleChannel("${modid[0..*18]}:a");

	@SidedProxy(clientSide = "${package}.ClientProxy${JavaModName}", serverSide = "${package}.ServerProxy${JavaModName}")
	public static IProxy${JavaModName} proxy;

	@Mod.Instance(MODID) public static ${JavaModName} instance;

	@Mod.EventHandler public void preInit(FMLPreInitializationEvent event) {
		MinecraftForge.EVENT_BUS.register(this);

		proxy.preInit(event);
		// Start of user code block mod init
		// End of user code block mod init
	}

	// Start of user code block mod methods
	// End of user code block mod methods

	private static int messageID = 0;

	public static <T extends IMessage, V extends IMessage> void addNetworkMessage(Class<? extends IMessageHandler<T, V>> handler, Class<T> messageClass, Side... sides) {
		for (Side side : sides)
			${JavaModName}.PACKET_HANDLER.registerMessage(handler, messageClass, messageID, side);
		messageID++;
	}

	private static final Collection<AbstractMap.SimpleEntry<Runnable, Integer>> workQueue = new ConcurrentLinkedQueue<>();

	public static void queueServerWork(int tick, Runnable action) {
		if (Thread.currentThread().getThreadGroup() == SidedThreadGroups.SERVER)
			workQueue.add(new AbstractMap.SimpleEntry<>(action, tick));
	}

	@SubscribeEvent public void tick(TickEvent.ServerTickEvent event) {
		if (event.phase == TickEvent.Phase.END) {
			List<AbstractMap.SimpleEntry<Runnable, Integer>> actions = new ArrayList<>();
			workQueue.forEach(work -> {
				work.setValue(work.getValue() - 1);
				if (work.getValue() == 0)
					actions.add(work);
			});
			actions.forEach(e -> e.getKey().run());
			workQueue.removeAll(actions);
		}
	}

	static {FluidRegistry.enableUniversalBucket();}
}
<#-- @formatter:on -->
