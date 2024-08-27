<#-- @formatter:off -->
package ${package};

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

@Mod(modid = ${JavaModName}.MODID, version = "${settings.getVersion()}"
<#if settings.isServerSideOnly()>, acceptableRemoteVersions = "*"</#if>) public class ${JavaModName} {

	public static final Logger LOGGER = LogManager.getLogger(${JavaModName}.class);

	public static final String MODID = "${modid}";

	public static final SimpleNetworkWrapper PACKET_HANDLER =
		NetworkRegistry.INSTANCE.newSimpleChannel("${modid[0..*18]}:a");

	@SidedProxy(clientSide = "${package}.ClientProxy${JavaModName}", serverSide = "${package}.ServerProxy${JavaModName}")
	public static IProxy${JavaModName} proxy;

	@Mod.Instance(MODID) public static ${JavaModName} instance;

	public Elements${JavaModName} elements = new Elements${JavaModName}();

	@Mod.EventHandler public void preInit(FMLPreInitializationEvent event) {
		MinecraftForge.EVENT_BUS.register(this);

		GameRegistry.registerWorldGenerator(elements, 5);
		GameRegistry.registerFuelHandler(elements);
		NetworkRegistry.INSTANCE.registerGuiHandler(this, new Elements${JavaModName}.GuiHandler());
		elements.preInit(event);
		MinecraftForge.EVENT_BUS.register(elements);
		elements.getElements().forEach(element -> element.preInit(event));
		proxy.preInit(event);
	}

	private static int messageID = 0;

	public <T extends IMessage, V extends IMessage> void addNetworkMessage(Class<? extends IMessageHandler<T, V>> handler, Class<T> messageClass, Side... sides) {
		for (Side side : sides)
			${JavaModName}.PACKET_HANDLER.registerMessage(handler, messageClass, messageID, side);
		messageID++;
	}

	@Mod.EventHandler public void init(FMLInitializationEvent event) {
		elements.getElements().forEach(element -> element.init(event));
		proxy.init(event);
	}

	@Mod.EventHandler public void postInit(FMLPostInitializationEvent event) {
		proxy.postInit(event);
	}

    	@Mod.EventHandler public void serverLoad(FMLServerStartingEvent event) {
		elements.getElements().forEach(element -> element.serverLoad(event));
		proxy.serverLoad(event);
	}

	@SubscribeEvent public void registerBlocks(RegistryEvent.Register<Block> event) {
		event.getRegistry().registerAll(elements.getBlocks().stream().map(Supplier::get).toArray(Block[]::new));
	}

	@SubscribeEvent public void registerItems(RegistryEvent.Register<Item> event) {
		event.getRegistry().registerAll(elements.getItems().stream().map(Supplier::get).toArray(Item[]::new));
	}

	@SubscribeEvent public void registerBiomes(RegistryEvent.Register<Biome> event) {
		event.getRegistry().registerAll(elements.getBiomes().stream().map(Supplier::get).toArray(Biome[]::new));
	}

	@SubscribeEvent public void registerEntities(RegistryEvent.Register<EntityEntry> event) {
		event.getRegistry().registerAll(elements.getEntities().stream().map(Supplier::get).toArray(EntityEntry[]::new));
	}

	@SubscribeEvent public void registerEnchantments(RegistryEvent.Register<Enchantment> event) {
		event.getRegistry().registerAll(elements.getEnchantments().stream().map(Supplier::get).toArray(Enchantment[]::new));
	}

	@SubscribeEvent public void registerPotions(RegistryEvent.Register<Potion> event) {
		event.getRegistry().registerAll(elements.getPotions().stream().map(Supplier::get).toArray(Potion[]::new));
	}

	@SubscribeEvent public void registerSounds(RegistryEvent.Register<net.minecraft.util.SoundEvent> event) {
		elements.registerSounds(event);
	}

	@SubscribeEvent @SideOnly(Side.CLIENT) public void registerModels(ModelRegistryEvent event) {
		elements.getElements().forEach(element -> element.registerModels(event));
	}

	static {FluidRegistry.enableUniversalBucket();}
}
<#-- @formatter:on -->
