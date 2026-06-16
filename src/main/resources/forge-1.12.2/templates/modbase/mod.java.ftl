<#-- @formatter:off -->
package ${package};

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

@Mod(modid = ${JavaModName}.MODID, version = "${settings.getCleanVersion()}"
<#if settings.isServerSideOnly()>, serverSideOnly = true</#if>) public class ${JavaModName} {
	public static final Logger LOGGER = LogManager.getLogger(${JavaModName}.class);
	public static final String MODID = "${modid}";

	@SidedProxy(modId = ${JavaModName}.MODID, clientSide = "${package}.network.${JavaModName}ClientProxy", serverSide = "${package}.network.${JavaModName}CommonProxy")
	public static ${JavaModName}CommonProxy proxy;

	@Mod.EventHandler public void preInit(FMLPreInitializationEvent event) {
		// Start of user code block mod constructor
		// End of user code block mod constructor
		MinecraftForge.EVENT_BUS.register(this);

		<#if w.hasVariables()>${JavaModName}Variables.init();</#if>
		<#if w.getGElementsOfType('procedure')?filter(e -> e.procedurexml?contains('player_left_click_air') || e.procedurexml?contains('player_right_click_empty_hand'))?size != 0>${JavaModName}Procedures.load();</#if>
		<#if w.hasElementsOfType("keybind")>${JavaModName}KeyMappings.load();</#if>
		<#if w.hasElementsOfType("gui")>
		${JavaModName}Menus.load();
		${JavaModName}Screens.load(this);
		</#if>

		proxy.preInit(event);
		// Start of user code block mod init
		// End of user code block mod init
	}

	@Mod.EventHandler public void init(FMLInitializationEvent event) {
		<#if w.hasElementsOfType("biome")>${JavaModName}Biomes.init();</#if>
		<#if w.hasElementsOfType("livingentity")>${JavaModName}Entities.init();</#if>
		<#if w.getWorkspace().getTagElements().size() != 0>${JavaModName}Tags.load();</#if>
		<#if w.getGElementsOfType('recipe')?filter(e -> e.recipeType == 'Smelting' || e.recipeType == 'Brewing')?size != 0>${JavaModName}Recipes.load();</#if>
		<#if w.hasElementsOfType("loottable")>${JavaModName}Loottables.load();</#if>
		<#if w.hasElementsOfType("keybind")>${JavaModName}KeyMappings.registerKeyBindings();</#if>
		<#if w.getGElementsOfType('itemextension')?filter(e -> e.hasDispenseBehavior)?size != 0>${JavaModName}ItemExtensions.load();</#if>
		<#if w.hasElementsOfType("villagertrade")>${JavaModName}Trades.load();</#if>
		proxy.init(event);
	}

	@Mod.EventHandler public void postInit(FMLPostInitializationEvent event) {
		proxy.postInit(event);
	}

    @Mod.EventHandler public void serverLoad(FMLServerStartingEvent event) {
		proxy.serverLoad(event);
	}

	static {
	    FluidRegistry.enableUniversalBucket();
	}

	// Start of user code block mod methods
	// End of user code block mod methods

	public static final SimpleNetworkWrapper PACKET_HANDLER = NetworkRegistry.INSTANCE.newSimpleChannel("${modid[0..*18]}");

	private static int messageID = 0;

	public static <T extends IMessage, V extends IMessage> void addNetworkMessage(Class<? extends IMessageHandler<T, V>> messageHandler, Class<T> requestMessageType, Side... sides) {
		for (Side side : sides)
		PACKET_HANDLER.registerMessage(messageHandler, requestMessageType, messageID, side);
		messageID++;
	}

	<#-- Wait procedure block support below -->
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
}
<#-- @formatter:on -->